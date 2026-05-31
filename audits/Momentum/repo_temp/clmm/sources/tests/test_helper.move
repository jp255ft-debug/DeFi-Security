#[test_only]
module mmt_v3::test_helper;

use mmt_v3::create_pool;
use mmt_v3::global_config::{Self, GlobalConfig};
use mmt_v3::i32::{Self, I32};
use mmt_v3::liquidity;
use mmt_v3::pool::{Self, Pool};
use mmt_v3::position::Position;
use mmt_v3::version::{Self, Version};
use sui::clock::{Self, Clock};
use sui::coin;
use sui::test_scenario::{Self, Scenario};

const SUI_DECIMALS: u64 = 1_000_000_000;
const USDC_DECIMALS: u64 = 1_000_000;

public struct USDC has drop {}
public struct USDT has drop {}
public struct XSUI has drop {}
public struct WAL has drop {}
public struct HASUI has drop {}

public fun setup(ctx: &mut TxContext) {
    global_config::init_(ctx);
}

public fun take_config(scenario: &mut Scenario): GlobalConfig {
    test_scenario::take_shared<GlobalConfig>(scenario)
}

public fun return_config(global_config: GlobalConfig) {
    test_scenario::return_shared<GlobalConfig>(global_config);
}

public fun take_pool<X, Y>(scenario: &mut Scenario): Pool<X, Y> {
    test_scenario::take_shared<Pool<X, Y>>(scenario)
}

public fun return_pool<X, Y>(pool: Pool<X, Y>) {
    test_scenario::return_shared<Pool<X, Y>>(pool);
}

public fun take_position(scenario: &mut Scenario, user: address): Position {
    test_scenario::take_from_address<Position>(scenario, user)
}

public fun return_position(position: Position, user: address) {
    test_scenario::return_to_address<Position>(user, position);
}

public fun take_version(ctx: &mut TxContext): Version {
    version::init_(ctx)
}

public fun create_pool_<X, Y>(
    fee_rate: u64,
    sqrt_price: u128,
    to_initialise: bool,
    version: &Version,
    scenario: &mut Scenario,
) {
    let tester1 = @0xAF;

    setup(test_scenario::ctx(scenario));

    test_scenario::next_tx(scenario, tester1);
    let mut global_config = take_config(scenario);

    let mut pool = create_pool::new<X, Y>(
        &mut global_config,
        fee_rate,
        version,
        test_scenario::ctx(scenario),
    );
    if (to_initialise) {
        let clock = clock::create_for_testing(test_scenario::ctx(scenario));
        pool::initialize(
            &mut pool,
            sqrt_price,
            &clock,
        );
        clock::destroy_for_testing(clock);
    };
    return_config(global_config);
    pool::transfer<X, Y>(pool);
}

public fun add_liquidity_<X, Y>(
    pool: &mut Pool<X, Y>,
    amount_x: u64,
    amount_y: u64,
    mut lower_tick: I32,
    mut upper_tick: I32,
    user: address,
    clock: &Clock,
    version: &Version,
    scenario: &mut Scenario,
): (u64, u64, Position) {
    let tick_spacing = i32::from_u32(pool::tick_spacing(pool));
    upper_tick = i32::sub(upper_tick, i32::mod(upper_tick, tick_spacing));
    lower_tick = i32::sub(lower_tick, i32::mod(lower_tick, tick_spacing));
    test_scenario::next_tx(scenario, user);

    let mut position = liquidity::open_position<X, Y>(
        pool,
        lower_tick,
        upper_tick,
        version,
        test_scenario::ctx(scenario),
    );
    let sui_coin = coin::mint_for_testing<X>(amount_x * SUI_DECIMALS, test_scenario::ctx(scenario));
    let usdc_coin = coin::mint_for_testing<Y>(
        amount_y * USDC_DECIMALS,
        test_scenario::ctx(scenario),
    );

    let (refund_x, refund_y) = liquidity::add_liquidity(
        pool,
        &mut position,
        sui_coin,
        usdc_coin,
        0,
        0,
        clock,
        version,
        test_scenario::ctx(scenario),
    );

    let refund_x_amt = coin::burn_for_testing<X>(refund_x);
    let refund_y_amt = coin::burn_for_testing<Y>(refund_y);
    (refund_x_amt, refund_y_amt, position)
}

public fun add_liquidity_for_swap_mock<X, Y>(
    pool: &mut Pool<X, Y>,
    amount_x: u64,
    amount_y: u64,
    lower_tick: I32,
    upper_tick: I32,
    user: address,
    clock: &Clock,
    version: &Version,
    scenario: &mut Scenario,
): (u64, u64, Position) {
    test_scenario::next_tx(scenario, user);

    let mut position = liquidity::open_position<X, Y>(
        pool,
        lower_tick,
        upper_tick,
        version,
        test_scenario::ctx(scenario),
    );
    let sui_coin = coin::mint_for_testing<X>(amount_x, test_scenario::ctx(scenario));
    let usdc_coin = coin::mint_for_testing<Y>(amount_y, test_scenario::ctx(scenario));

    let (refund_x, refund_y) = liquidity::add_liquidity(
        pool,
        &mut position,
        sui_coin,
        usdc_coin,
        0,
        0,
        clock,
        version,
        test_scenario::ctx(scenario),
    );

    let refund_x_amt = coin::burn_for_testing<X>(refund_x);
    let refund_y_amt = coin::burn_for_testing<Y>(refund_y);
    (refund_x_amt, refund_y_amt, position)
}
