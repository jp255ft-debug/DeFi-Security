#[test_only]
module mmt_v3::wal_usdc_trade_test;

use mmt_v3::app::{Self, Acl};
use mmt_v3::full_math_u128;
use mmt_v3::i32;
use mmt_v3::pool::{Self, Pool};
use mmt_v3::test_helper::{Self as th, USDC, WAL, create_pool_, add_liquidity_for_swap_mock};
use mmt_v3::trade;
use mmt_v3::version::{Self, Version};
use sui::balance;
use sui::clock::{Self, Clock};
use sui::test_scenario::{Self, Scenario};
use sui::transfer::public_transfer;

const RESERVE_X: u64 = 428946448231495;
const RESERVE_Y: u64 = 105661220810;
const CURRENT_SQRT_PRICE: u128 = 372351498994803811; // -78060  -77460   -77316  -77300
const RESERVE_NUM: u128 = 74533999032471;
const RESERVE_DEN: u128 = 5237464258583521;

const PRICE_LIMIT: u128 = 4295048020;
const N1: u64 = 1_000_000_000;
const N10: u64 = 10_000_000_000;
const N100: u64 = 100_000_000_000;
const N500: u64 = 500_000_000_000;
const N600: u64 = 600_000_000_000;
const N700: u64 = 700_000_000_000;
const N800: u64 = 800_000_000_000;

const FACTOR: u32 = 3;
const LOWER_TICK: u32 = 78120; // 77320 77520 77560
const UPPER_TICK: u32 = 78000; // 77280 77400 77360

// Helper function to setup test environment
fun setup_test_environment(scenario: &mut Scenario): (Version, Clock, Acl) {
    let version = th::take_version(test_scenario::ctx(scenario));
    let clock = clock::create_for_testing(test_scenario::ctx(scenario));
    let acl = app::create_acl_for_testing(test_scenario::ctx(scenario));
    (version, clock, acl)
}

// Helper function to create and initialize pool
fun create_and_init_pool(scenario: &mut Scenario, version: &Version) {
    let tester1 = @0xAF;
    create_pool_<WAL, USDC>(2000, CURRENT_SQRT_PRICE, true, version, scenario);
    test_scenario::next_tx(scenario, tester1);
}

// Helper function to setup pool with tick range factor
fun setup_pool_with_tick_range(
    scenario: &mut Scenario,
    version: &Version,
    acl: &Acl,
    tick_range_factor: u32,
): Pool<WAL, USDC> {
    let tester1 = @0xAF;
    let mut pool = th::take_pool<WAL, USDC>(scenario);
    if (tick_range_factor > 1) {
        pool::set_min_tick_range_factor(
            acl,
            &mut pool,
            tick_range_factor,
            version,
            test_scenario::ctx(scenario),
        );
        test_scenario::next_tx(scenario, tester1);
    };
    pool
}

// Helper function to add liquidity
fun add_liquidity_to_pool(
    pool: &mut Pool<WAL, USDC>,
    lower_tick: i32::I32,
    upper_tick: i32::I32,
    scenario: &mut Scenario,
    clock: &Clock,
    version: &Version,
) {
    let tester1 = @0xAF;
    let (_, _, position) = add_liquidity_for_swap_mock<WAL, USDC>(
        pool,
        full_math_u128::mul_div_floor(RESERVE_X as u128, RESERVE_NUM, RESERVE_DEN) as u64,
        full_math_u128::mul_div_floor(RESERVE_Y as u128, RESERVE_NUM, RESERVE_DEN) as u64,
        lower_tick,
        upper_tick,
        tester1,
        clock,
        version,
        scenario,
    );
    public_transfer(position, tester1);
    test_scenario::next_tx(scenario, tester1);
}

// Helper function to execute flash swap
fun execute_flash_swap(
    pool: &mut Pool<WAL, USDC>,
    swap_amount: u64,
    scenario: &mut Scenario,
    clock: &Clock,
    version: &Version,
) {
    let (balanceX, balanceY, receipt) = trade::flash_swap<WAL, USDC>(
        pool,
        true,
        true,
        swap_amount,
        PRICE_LIMIT,
        clock,
        version,
        test_scenario::ctx(scenario),
    );
    let (pay_x, pay_y) = trade::swap_receipt_debts(&receipt);
    trade::repay_flash_swap(
        pool,
        receipt,
        balance::create_for_testing<WAL>(pay_x),
        balance::create_for_testing<USDC>(pay_y),
        version,
        test_scenario::ctx(scenario),
    );

    balanceX.destroy_for_testing();
    balanceY.destroy_for_testing();
}

// Helper function to cleanup test environment
fun cleanup_test_environment(
    pool: Pool<WAL, USDC>,
    version: Version,
    clock: Clock,
    acl: Acl,
    scenario: Scenario,
) {
    th::return_pool<WAL, USDC>(pool);
    version::destroy_version_for_testing(version);
    clock::destroy_for_testing(clock);
    app::destroy_acl_for_testing(acl);
    test_scenario::end(scenario);
}

// Main test function template
fun run_test(swap_amount: u64, tick_range_factor: u32, lower_tick: i32::I32, upper_tick: i32::I32) {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);

    let (version, clock, acl) = setup_test_environment(&mut scenario);
    create_and_init_pool(&mut scenario, &version);

    let mut pool = setup_pool_with_tick_range(&mut scenario, &version, &acl, tick_range_factor);
    add_liquidity_to_pool(&mut pool, lower_tick, upper_tick, &mut scenario, &clock, &version);
    execute_flash_swap(&mut pool, swap_amount, &mut scenario, &clock, &version);

    cleanup_test_environment(pool, version, clock, acl, scenario);
}

#[test]
public fun test_wal_usdc_1() {
    run_test(N1, FACTOR, i32::neg_from(LOWER_TICK), i32::neg_from(UPPER_TICK));
}

#[test]
public fun test_wal_usdc_10() {
    run_test(N10, FACTOR, i32::neg_from(LOWER_TICK), i32::neg_from(UPPER_TICK));
}

#[test]
public fun test_wal_usdc_100() {
    run_test(N100, FACTOR, i32::neg_from(LOWER_TICK), i32::neg_from(UPPER_TICK));
}

#[test]
public fun test_wal_usdc_500() {
    run_test(N500, FACTOR, i32::neg_from(LOWER_TICK), i32::neg_from(UPPER_TICK));
}

#[test]
public fun test_wal_usdc_600() {
    run_test(N600, FACTOR, i32::neg_from(LOWER_TICK), i32::neg_from(UPPER_TICK));
}

#[test]
public fun test_wal_usdc_700() {
    run_test(N700, FACTOR, i32::neg_from(LOWER_TICK), i32::neg_from(UPPER_TICK));
}

#[test]
public fun test_wal_usdc_800() {
    run_test(N800, FACTOR, i32::neg_from(LOWER_TICK), i32::neg_from(UPPER_TICK));
}
