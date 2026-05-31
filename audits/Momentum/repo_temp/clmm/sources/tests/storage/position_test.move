#[test_only]
module mmt_v3::position_test;

use mmt_v3::i32;
use mmt_v3::liquidity;
use mmt_v3::pool::{Self, Pool};
use mmt_v3::position::{Self, Position};
use mmt_v3::test_helper::{Self as th, USDC, create_pool_, add_liquidity_};
use mmt_v3::version::{Self, Version};
use sui::clock::{Self, Clock};
use sui::coin;
use sui::sui::SUI;
use sui::test_scenario::{Self, Scenario};
use sui::transfer::public_transfer;

const CURRENT_SQRT_PRICE: u128 = 1161864593404260289; // -55300
const RESERVE_X: u64 = 2052418;
const RESERVE_Y: u64 = 8657600;

const LOWER_TICK: u32 = 55440;
const UPPER_TICK: u32 = 55160;

// Helper function to setup test environment
fun setup_test_environment(scenario: &mut Scenario): (Version, Clock) {
    let version = th::take_version(test_scenario::ctx(scenario));
    let clock = clock::create_for_testing(test_scenario::ctx(scenario));
    (version, clock)
}

// Helper function to create and initialize pool
fun create_and_init_pool(scenario: &mut Scenario, version: &Version) {
    let tester1 = @0xAF;
    create_pool_<SUI, USDC>(2000, CURRENT_SQRT_PRICE, true, version, scenario);
    test_scenario::next_tx(scenario, tester1);
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
    let (_, _, position) = add_liquidity_<SUI, USDC>(
        pool,
        RESERVE_X,
        RESERVE_Y,
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

// Helper function to cleanup test environment
fun cleanup_test_environment(
    pool: Pool<SUI, USDC>,
    position: Position,
    user: address,
    version: Version,
    clock: Clock,
    scenario: Scenario,
) {
    th::return_position(position, user);
    th::return_pool<SUI, USDC>(pool);
    version::destroy_version_for_testing(version);
    clock::destroy_for_testing(clock);
    test_scenario::end(scenario);
}

#[test]
public fun test_position_is_empty() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);

    let (version, clock) = setup_test_environment(&mut scenario);
    create_and_init_pool(&mut scenario, &version);

    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);
    add_liquidity_to_pool(
        &mut pool,
        i32::neg_from(LOWER_TICK),
        i32::neg_from(UPPER_TICK),
        &mut scenario,
        &clock,
        &version,
    );

    let mut position = th::take_position(&mut scenario, tester1);
    assert!(!position::is_empty(&position));

    test_scenario::next_tx(&mut scenario, tester1);
    let liquidity = position::liquidity(&position);
    let (asset_a, asset_b) = liquidity::remove_liquidity<SUI, USDC>(
        &mut pool,
        &mut position,
        liquidity,
        0,
        0,
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );
    coin::burn_for_testing<SUI>(asset_a);
    coin::burn_for_testing<USDC>(asset_b);
    test_scenario::next_tx(&mut scenario, tester1);

    assert!(position::is_empty(&position));

    cleanup_test_environment(pool, position, tester1, version, clock, scenario);
}

#[test]
public fun test_position_coins_init_state() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);

    let (version, clock) = setup_test_environment(&mut scenario);
    create_and_init_pool(&mut scenario, &version);

    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);
    add_liquidity_to_pool(
        &mut pool,
        i32::neg_from(LOWER_TICK),
        i32::neg_from(UPPER_TICK),
        &mut scenario,
        &clock,
        &version,
    );

    let position = th::take_position(&mut scenario, tester1);
    assert!(position::coins_owed_reward(&position, 0) == 0);
    assert!(position::reward_growth_inside_last(&position, 0) == 0);
    assert!(position::reward_length(&position) == 0);
    assert!(position::tick_lower_index(&position) == i32::neg_from(LOWER_TICK));
    assert!(position::tick_upper_index(&position) == i32::neg_from(UPPER_TICK));
    assert!(position::liquidity(&position) > 0);
    assert!(position::owed_coin_x(&position) == 0);
    assert!(position::owed_coin_y(&position) == 0);
    assert!(position::fee_growth_inside_x_last(&position) == 0);
    assert!(position::fee_growth_inside_y_last(&position) == 0);
    assert!(position::fee_rate(&position) == 2000);
    assert!(position::pool_id(&position) == pool::pool_id(&pool));

    cleanup_test_environment(pool, position, tester1, version, clock, scenario);
}
