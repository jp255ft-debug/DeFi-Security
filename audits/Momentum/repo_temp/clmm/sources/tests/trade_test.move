#[test_only]
module mmt_v3::trade_test;

use mmt_v3::app::{Self, Acl};
use mmt_v3::constants;
use mmt_v3::full_math_u64;
use mmt_v3::i32;
use mmt_v3::pool;
use mmt_v3::position::Position;
use mmt_v3::test_helper::{Self as th, USDC, create_pool_, add_liquidity_};
use mmt_v3::tick_math;
use mmt_v3::trade;
use mmt_v3::version;
use sui::balance;
use sui::clock;
use sui::sui::SUI;
use sui::test_scenario;
use sui::transfer::public_transfer;

const SUI_DECIMALS: u64 = 1_000_000_000;
const USDC_DECIMALS: u64 = 1_000_000;
const DEFAULT_FEE_RATE: u64 = 100;
const DEFAULT_SQRT_PRICE: u128 = 597742825358017408; // sqrt price 1.05
const DEFAULT_LOWER_TICK: u128 = 583337266871351552; // lower price 1.0
const DEFAULT_UPPER_TICK: u128 = 611809286962066560; // upper price 1.1
const DEFAULT_LIQUIDITY_AMOUNT: u64 = 1000;

fun setup_test_environment<X, Y>(): (
    test_scenario::Scenario,
    version::Version,
    pool::Pool<X, Y>,
    Acl,
    clock::Clock,
    address,
) {
    let tester = @0xAF;
    let mut scenario = test_scenario::begin(tester);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<X, Y>(
        DEFAULT_FEE_RATE,
        DEFAULT_SQRT_PRICE,
        true,
        &version,
        &mut scenario,
    );

    test_scenario::next_tx(&mut scenario, tester);
    let pool = th::take_pool<X, Y>(&mut scenario);
    let admin_cap = app::create_acl_for_testing(test_scenario::ctx(&mut scenario));
    let clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));

    (scenario, version, pool, admin_cap, clock, tester)
}

fun add_liquidity_to_pool<X, Y>(
    pool: &mut pool::Pool<X, Y>,
    clock: &clock::Clock,
    version: &version::Version,
    scenario: &mut test_scenario::Scenario,
    tester: address,
): (u64, u64, Position) {
    let lower_tick = tick_math::get_tick_at_sqrt_price(DEFAULT_LOWER_TICK);
    let upper_tick = tick_math::get_tick_at_sqrt_price(DEFAULT_UPPER_TICK);

    let (balance_x, balance_y, position) = add_liquidity_<X, Y>(
        pool,
        DEFAULT_LIQUIDITY_AMOUNT,
        DEFAULT_LIQUIDITY_AMOUNT,
        lower_tick,
        upper_tick,
        tester,
        clock,
        version,
        scenario,
    );

    (balance_x, balance_y, position)
}

fun cleanup_test_environment<X, Y>(
    scenario: test_scenario::Scenario,
    version: version::Version,
    pool: pool::Pool<X, Y>,
    admin_cap: Acl,
    clock: clock::Clock,
) {
    th::return_pool<X, Y>(pool);
    clock::destroy_for_testing(clock);
    version::destroy_version_for_testing(version);
    app::destroy_acl_for_testing(admin_cap);
    test_scenario::end(scenario);
}

#[test]
public fun test_get_effective_fee_rate_flash_loan_zero() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));
    create_pool_<SUI, USDC>(100, 583337266871351588, true, &version, &mut scenario);
    test_scenario::next_tx(&mut scenario, tester1);

    let pool = th::take_pool<SUI, USDC>(&mut scenario);
    let rate = trade::get_effective_fee_rate(&pool);
    th::return_pool<SUI, USDC>(pool);
    assert!(rate == 100);

    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
public fun test_flash_loan() {
    let (mut scenario, version, mut pool, admin_cap, clock, tester) = setup_test_environment<
        SUI,
        USDC,
    >();

    let (_, _, position) = add_liquidity_to_pool<SUI, USDC>(
        &mut pool,
        &clock,
        &version,
        &mut scenario,
        tester,
    );
    public_transfer(position, tester);
    test_scenario::next_tx(&mut scenario, tester);

    let fee_rate = pool::flash_loan_fee_rate(&pool);
    let amount_x = 10 * SUI_DECIMALS;
    let amount_y = 10 * USDC_DECIMALS;
    let (balance_x, blance_y, recipt) = trade::flash_loan(
        &mut pool,
        amount_x,
        amount_y,
        &version,
        test_scenario::ctx(&mut scenario),
    );
    balance::destroy_for_testing<SUI>(balance_x);
    balance::destroy_for_testing<USDC>(blance_y);

    test_scenario::next_tx(&mut scenario, tester);

    let fee_x = full_math_u64::mul_div_round(
        amount_x,
        fee_rate,
        constants::fee_rate_denominator(),
    );
    let fee_y = full_math_u64::mul_div_round(
        amount_y,
        fee_rate,
        constants::fee_rate_denominator(),
    );
    let (pay_x, pay_y) = trade::flash_receipt_debts(&recipt);
    assert!(pay_x == amount_x + fee_x);
    assert!(pay_y == amount_y + fee_y);

    trade::repay_flash_loan(
        &mut pool,
        recipt,
        balance::create_for_testing(pay_x),
        balance::create_for_testing(pay_y),
        &version,
        test_scenario::ctx(&mut scenario),
    );

    cleanup_test_environment<SUI, USDC>(scenario, version, pool, admin_cap, clock);
}

#[test]
public fun calculate_max_out() {
    let (mut scenario, version, mut pool, admin_cap, clock, tester) = setup_test_environment<
        SUI,
        USDC,
    >();
    create_pool_<SUI, USDC>(
        100,
        583337266871351588,
        true,
        &version,
        &mut scenario,
    );

    test_scenario::next_tx(&mut scenario, tester);
    let lower_tick = tick_math::get_tick_at_sqrt_price(553402322211286548); // lower price 0.9
    let upper_tick = tick_math::get_tick_at_sqrt_price(611809286962066562); // upper price 1.1
    let (_, _, position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 100 sui
        1000, // 100 usdc
        lower_tick,
        upper_tick,
        tester,
        &clock,
        &version,
        &mut scenario,
    );
    transfer::public_transfer(position, tester);

    let max_out_result = trade::compute_swap_result_max<SUI, USDC>(
        &pool,
        true,
        true,
        553402322211286548,
    );
    assert!(trade::get_state_fee_amount(&max_out_result) == 82300616);
    assert!(trade::get_state_amount_calculated(&max_out_result) == 999999999);
    assert!(trade::get_state_fee_growth_global(&max_out_result) == 3647737652224628);
    assert!(trade::get_state_protocol_fee(&max_out_result) == 20575153);
    assert!(trade::get_state_sqrt_price(&max_out_result) == 553402322211286548);
    assert!(trade::get_state_liquidity(&max_out_result) == 0);
    assert!(trade::get_state_tick_index(&max_out_result) == i32::neg_from(70135));

    cleanup_test_environment<SUI, USDC>(scenario, version, pool, admin_cap, clock);
}

#[test, expected_failure]
public fun repay_flash_loan_insufficient() {
    let (mut scenario, version, mut pool, admin_cap, clock, tester) = setup_test_environment<
        SUI,
        USDC,
    >();

    create_pool_<SUI, USDC>(100, 583337266871351588, true, &version, &mut scenario);
    test_scenario::next_tx(&mut scenario, tester);
    let (_, _, position) = add_liquidity_to_pool<SUI, USDC>(
        &mut pool,
        &clock,
        &version,
        &mut scenario,
        tester,
    );
    sui::transfer::public_transfer(position, tester);
    test_scenario::next_tx(&mut scenario, tester);

    let amount_x = 10 * SUI_DECIMALS;
    let amount_y = 10 * USDC_DECIMALS;

    let (balance_x, balance_y, r) = trade::flash_loan<SUI, USDC>(
        &mut pool,
        amount_x,
        amount_y,
        &version,
        test_scenario::ctx(&mut scenario),
    );
    balance_x.destroy_for_testing();
    balance_y.destroy_for_testing();
    trade::repay_flash_loan<SUI, USDC>(
        &mut pool,
        r,
        balance::create_for_testing<SUI>(amount_x),
        balance::create_for_testing<USDC>(amount_y),
        &version,
        test_scenario::ctx(&mut scenario),
    );
    cleanup_test_environment<SUI, USDC>(scenario, version, pool, admin_cap, clock);
}

#[test, expected_failure]
public fun repay_flash_swap_insufficient() {
    let (mut scenario, version, mut pool, admin_cap, clock, tester) = setup_test_environment<
        SUI,
        USDC,
    >();

    create_pool_<SUI, USDC>(100, 583337266871351588, true, &version, &mut scenario);
    test_scenario::next_tx(&mut scenario, tester);
    let (_, _, position) = add_liquidity_to_pool<SUI, USDC>(
        &mut pool,
        &clock,
        &version,
        &mut scenario,
        tester,
    );
    sui::transfer::public_transfer(position, tester);
    test_scenario::next_tx(&mut scenario, tester);

    let (balance_x, balance_y, rec) = trade::flash_swap<SUI, USDC>(
        &mut pool,
        true,
        true,
        100,
        4295048076,
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );
    balance_x.destroy_for_testing();
    balance_y.destroy_for_testing();
    test_scenario::next_tx(&mut scenario, tester);

    let (pay_x, pay_y) = trade::swap_receipt_debts(&rec);
    trade::repay_flash_swap<SUI, USDC>(
        &mut pool,
        rec,
        balance::create_for_testing<SUI>(pay_x - 1),
        balance::create_for_testing<USDC>(pay_y),
        &version,
        test_scenario::ctx(&mut scenario),
    );

    cleanup_test_environment<SUI, USDC>(scenario, version, pool, admin_cap, clock);
}
