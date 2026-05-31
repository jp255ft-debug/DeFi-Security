#[test_only]
module mmt_v3::sui_usdc_trade_test;

use mmt_v3::app::{Self, Acl};
use mmt_v3::full_math_u128;
use mmt_v3::i32;
use mmt_v3::pool::{Self, Pool};
use mmt_v3::test_helper::{Self as th, USDC, create_pool_, add_liquidity_for_swap_mock};
use mmt_v3::trade;
use mmt_v3::version::{Self, Version};
use sui::balance;
use sui::clock::{Self, Clock};
use sui::sui::SUI;
use sui::test_scenario::{Self, Scenario};
use sui::transfer::public_transfer;

const RESERVE_X: u64 = 2052418411499282;
const RESERVE_Y: u64 = 8657600293181;
const CURRENT_SQRT_PRICE: u128 = 1161864593404260289; // -55300
const RESERVE_NUM: u128 = 21707074480945573;
const RESERVE_DEN: u128 = 128055371695633834;

const PRICE_LIMIT: u128 = 4295048020;
const N1: u64 = 1_000_000_000;
const N10: u64 = 10_000_000_000;
const N100: u64 = 100_000_000_000;
const N1000: u64 = 1000_000_000_000;
const N10000: u64 = 1_0000_000_000_000;
const N100000: u64 = 100_000_000_000_000;
const N200000: u64 = 200_000_000_000_000;
const N300000: u64 = 300_000_000_000_000;

const FACTOR: u32 = 7;
const LOWER_TICK: u32 = 55440; // 55360 55400  55440
const UPPER_TICK: u32 = 55160; // 55240 55200  55160

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
    create_pool_<SUI, USDC>(2000, CURRENT_SQRT_PRICE, true, version, scenario);
    test_scenario::next_tx(scenario, tester1);
}

// Helper function to setup pool with tick range factor
fun setup_pool_with_tick_range(
    scenario: &mut Scenario,
    version: &Version,
    acl: &Acl,
    tick_range_factor: u32,
): Pool<SUI, USDC> {
    let tester1 = @0xAF;
    let mut pool = th::take_pool<SUI, USDC>(scenario);
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
    pool: &mut Pool<SUI, USDC>,
    lower_tick: i32::I32,
    upper_tick: i32::I32,
    scenario: &mut Scenario,
    clock: &Clock,
    version: &Version,
) {
    let tester1 = @0xAF;
    let (_, _, position) = add_liquidity_for_swap_mock<SUI, USDC>(
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
    pool: &mut Pool<SUI, USDC>,
    swap_amount: u64,
    scenario: &mut Scenario,
    clock: &Clock,
    version: &Version,
) {
    let (balanceX, balanceY, receipt) = trade::flash_swap<SUI, USDC>(
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
        balance::create_for_testing<SUI>(pay_x),
        balance::create_for_testing<USDC>(pay_y),
        version,
        test_scenario::ctx(scenario),
    );

    balanceX.destroy_for_testing();
    balanceY.destroy_for_testing();
}

// Helper function to cleanup test environment
fun cleanup_test_environment(
    pool: Pool<SUI, USDC>,
    version: Version,
    clock: Clock,
    acl: Acl,
    scenario: Scenario,
) {
    th::return_pool<SUI, USDC>(pool);
    version::destroy_version_for_testing(version);
    clock::destroy_for_testing(clock);
    app::destroy_acl_for_testing(acl);
    test_scenario::end(scenario);
}

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
public fun test_sui_usdc_1() {
    run_test(N1, FACTOR, i32::neg_from(LOWER_TICK), i32::neg_from(UPPER_TICK));
}

#[test]
public fun test_sui_usdc_10() {
    run_test(N10, FACTOR, i32::neg_from(LOWER_TICK), i32::neg_from(UPPER_TICK));
}

#[test]
public fun test_sui_usdc_100() {
    run_test(N100, FACTOR, i32::neg_from(LOWER_TICK), i32::neg_from(UPPER_TICK));
}

#[test]
public fun test_sui_usdc_1000() {
    run_test(N1000, FACTOR, i32::neg_from(LOWER_TICK), i32::neg_from(UPPER_TICK));
}

#[test]
public fun test_sui_usdc_10000() {
    run_test(N10000, FACTOR, i32::neg_from(LOWER_TICK), i32::neg_from(UPPER_TICK));
}

#[test]
public fun test_sui_usdc_100000() {
    run_test(N100000, FACTOR, i32::neg_from(LOWER_TICK), i32::neg_from(UPPER_TICK));
}

#[test]
public fun test_sui_usdc_200000() {
    run_test(N200000, FACTOR, i32::neg_from(LOWER_TICK), i32::neg_from(UPPER_TICK));
}

#[test]
public fun test_sui_usdc_300000() {
    run_test(N300000, FACTOR, i32::neg_from(LOWER_TICK), i32::neg_from(UPPER_TICK));
}
