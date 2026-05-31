#[test_only]
module mmt_v3::admin_test;

use mmt_v3::admin;
use mmt_v3::app::{Self, Acl};
use mmt_v3::constants;
use mmt_v3::full_math_u128;
use mmt_v3::pool;
use mmt_v3::position::Position;
use mmt_v3::test_helper::{Self as th, USDC, create_pool_, add_liquidity_};
use mmt_v3::tick_math;
use mmt_v3::trade;
use mmt_v3::utils;
use mmt_v3::version;
use sui::balance;
use sui::clock;
use sui::sui::SUI;
use sui::test_scenario;

const SUI_DECIMALS: u64 = 1_000_000_000;
const USDC_DECIMALS: u64 = 1_000_000;
const DEFAULT_FEE_RATE: u64 = 100;
const DEFAULT_SQRT_PRICE: u128 = 597742825358017408; // sqrt price 1.05
const DEFAULT_LOWER_TICK: u128 = 583337266871351552; // lower price 1.0
const DEFAULT_UPPER_TICK: u128 = 611809286962066560; // upper price 1.1
const DEFAULT_LIQUIDITY_AMOUNT: u64 = 1000;
const DEFAULT_REWARD_AMOUNT: u64 = 100;
const DEFAULT_REWARD_DURATION: u64 = 3600000;

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

fun init_pool_reward<X, Y>(
    admin_cap: &Acl,
    pool: &mut pool::Pool<X, Y>,
    clock: &clock::Clock,
    version: &version::Version,
    scenario: &mut test_scenario::Scenario,
    reward_amount: u64,
    duration: u64,
) {
    let start_time: u64 = 1754465786;
    let initial_balance = balance::create_for_testing<Y>(reward_amount * USDC_DECIMALS);

    admin::initialize_pool_reward(
        admin_cap,
        pool,
        start_time,
        duration,
        initial_balance,
        clock,
        version,
        test_scenario::ctx(scenario),
    );
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

fun perform_flash_swap<X, Y>(
    pool: &mut pool::Pool<X, Y>,
    clock: &clock::Clock,
    version: &version::Version,
    scenario: &mut test_scenario::Scenario,
    is_x_to_y: bool,
    amount: u64,
    sqrt_price_limit: u128,
) {
    let (balance_x, balance_y, swap_receipt) = trade::flash_swap<X, Y>(
        pool,
        is_x_to_y,
        true,
        amount,
        sqrt_price_limit,
        clock,
        version,
        test_scenario::ctx(scenario),
    );

    balance_x.destroy_for_testing();
    balance_y.destroy_for_testing();

    let (pay_x, pay_y) = trade::swap_receipt_debts(&swap_receipt);
    trade::repay_flash_swap<X, Y>(
        pool,
        swap_receipt,
        balance::create_for_testing<X>(pay_x),
        balance::create_for_testing<Y>(pay_y),
        version,
        test_scenario::ctx(scenario),
    );
}

#[test]
public fun test_initialize_pool_reward() {
    let (mut scenario, version, mut pool, admin_cap, clock, _) = setup_test_environment<
        SUI,
        USDC,
    >();

    init_pool_reward<SUI, USDC>(
        &admin_cap,
        &mut pool,
        &clock,
        &version,
        &mut scenario,
        DEFAULT_REWARD_AMOUNT,
        DEFAULT_REWARD_DURATION,
    );

    let reward_per_seconds: u128 = full_math_u128::mul_div_floor(
        (DEFAULT_REWARD_AMOUNT * USDC_DECIMALS) as u128,
        mmt_v3::constants::q64() as u128,
        (DEFAULT_REWARD_DURATION as u128),
    );

    assert!(pool::reward_per_seconds(&pool, 0) == reward_per_seconds);
    assert!(pool::total_reward(&pool, 0) == DEFAULT_REWARD_AMOUNT * USDC_DECIMALS);

    cleanup_test_environment(scenario, version, pool, admin_cap, clock);
}

#[test]
public fun test_collect_protocol_fee() {
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
    transfer::public_transfer(position, tester);

    test_scenario::next_tx(&mut scenario, tester);

    perform_flash_swap<SUI, USDC>(
        &mut pool,
        &clock,
        &version,
        &mut scenario,
        true,
        10 * SUI_DECIMALS,
        42999940923,
    );
    perform_flash_swap<SUI, USDC>(
        &mut pool,
        &clock,
        &version,
        &mut scenario,
        false,
        100 * USDC_DECIMALS,
        DEFAULT_UPPER_TICK,
    );

    test_scenario::next_tx(&mut scenario, tester);

    let (balance_x, balance_y) = admin::collect_protocol_fee<SUI, USDC>(
        &admin_cap,
        &mut pool,
        10,
        10,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    assert!(balance_x.value() == 10);
    assert!(balance_y.value() == 10);

    balance_x.destroy_for_testing();
    balance_y.destroy_for_testing();

    cleanup_test_environment(scenario, version, pool, admin_cap, clock);
}

#[test]
public fun test_add_seconds_to_reward_emission() {
    let (mut scenario, version, mut pool, admin_cap, clock, _) = setup_test_environment<
        SUI,
        USDC,
    >();

    init_pool_reward<SUI, USDC>(
        &admin_cap,
        &mut pool,
        &clock,
        &version,
        &mut scenario,
        DEFAULT_REWARD_AMOUNT,
        DEFAULT_REWARD_DURATION,
    );
    test_scenario::next_tx(&mut scenario, @0xAF);

    admin::add_seconds_to_reward_emission<SUI, USDC, USDC>(
        &admin_cap,
        &mut pool,
        DEFAULT_REWARD_DURATION,
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    let reward_per_seconds: u128 = full_math_u128::mul_div_floor(
        (DEFAULT_REWARD_AMOUNT * USDC_DECIMALS) as u128,
        mmt_v3::constants::q64() as u128,
        (DEFAULT_REWARD_DURATION * 2 as u128),
    );

    assert!(pool::reward_per_seconds(&pool, 0) == reward_per_seconds);
    assert!(pool::total_reward(&pool, 0) == DEFAULT_REWARD_AMOUNT * USDC_DECIMALS);

    cleanup_test_environment(scenario, version, pool, admin_cap, clock);
}

#[test]
public fun test_update_pool_reward_emission() {
    let (mut scenario, version, mut pool, admin_cap, clock, _) = setup_test_environment<
        SUI,
        USDC,
    >();

    init_pool_reward<SUI, USDC>(
        &admin_cap,
        &mut pool,
        &clock,
        &version,
        &mut scenario,
        DEFAULT_REWARD_AMOUNT,
        DEFAULT_REWARD_DURATION,
    );
    test_scenario::next_tx(&mut scenario, @0xAF);

    let additional_balance = balance::create_for_testing<USDC>(
        DEFAULT_REWARD_AMOUNT * USDC_DECIMALS,
    );

    admin::update_pool_reward_emission<SUI, USDC, USDC>(
        &admin_cap,
        &mut pool,
        additional_balance,
        DEFAULT_REWARD_DURATION,
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    let reward_per_seconds: u128 = full_math_u128::mul_div_floor(
        (DEFAULT_REWARD_AMOUNT * USDC_DECIMALS * 2) as u128,
        mmt_v3::constants::q64() as u128,
        (DEFAULT_REWARD_DURATION * 2) as u128,
    );

    assert!(pool::reward_per_seconds(&pool, 0) == reward_per_seconds);
    assert!(pool::total_reward(&pool, 0) == DEFAULT_REWARD_AMOUNT * USDC_DECIMALS * 2);

    cleanup_test_environment(scenario, version, pool, admin_cap, clock);
}

#[test]
#[expected_failure(abort_code = 4, location = mmt_v3::admin)]
public fun set_negative_protocol_flash_loan_fee_share() {
    let (mut scenario, version, mut pool, admin_cap, clock, _) = setup_test_environment<
        SUI,
        USDC,
    >();

    admin::set_protocol_flash_loan_fee_share<SUI, USDC>(
        &admin_cap,
        &mut pool,
        constants::protocol_fee_share_denominator() * constants::max_protocol_fee_percent() + 1,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    cleanup_test_environment(scenario, version, pool, admin_cap, clock);
}

#[test]
public fun test_set_protocol_flash_loan_fee_share_success() {
    let (mut scenario, version, mut pool, admin_cap, clock, user) = setup_test_environment<
        SUI,
        USDC,
    >();

    admin::set_protocol_flash_loan_fee_share<SUI, USDC>(
        &admin_cap,
        &mut pool,
        constants::protocol_fee_share_denominator() * constants::max_protocol_fee_percent() / 100,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    let r0 = test_scenario::next_tx(&mut scenario, user);
    assert!(
        pool::protocol_flash_loan_fee_share(&pool) == constants::protocol_fee_share_denominator() * constants::max_protocol_fee_percent() / 100,
    );
    assert!(r0.num_user_events() == 1);

    cleanup_test_environment(scenario, version, pool, admin_cap, clock);
}

#[test]
#[expected_failure(abort_code = 4, location = mmt_v3::admin)]
public fun test_set_protocol_swap_fee_share() {
    let (mut scenario, version, mut pool, admin_cap, clock, _) = setup_test_environment<
        SUI,
        USDC,
    >();

    admin::set_protocol_swap_fee_share<SUI, USDC>(
        &admin_cap,
        &mut pool,
        constants::protocol_fee_share_denominator() * constants::max_protocol_fee_percent() + 1,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    cleanup_test_environment(scenario, version, pool, admin_cap, clock);
}

#[test]
public fun test_set_protocol_swap_fee_share_success() {
    let (mut scenario, version, mut pool, admin_cap, clock, tester) = setup_test_environment<
        SUI,
        USDC,
    >();

    admin::set_protocol_swap_fee_share<SUI, USDC>(
        &admin_cap,
        &mut pool,
        constants::protocol_fee_share_denominator() * constants::max_protocol_fee_percent() / 100,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    let re0 = test_scenario::next_tx(&mut scenario, tester);
    assert!(re0.num_user_events() == 1);

    cleanup_test_environment(scenario, version, pool, admin_cap, clock);
}

#[test]
public fun test_get_max_protocol_fee_share() {
    let expected =
        constants::protocol_fee_share_denominator() * constants::max_protocol_fee_percent() / 100;
    let actual = admin::get_max_protocol_fee_share();
    assert!(expected == actual);
}

#[test]
public fun set_flash_loan_fee_rate_success() {
    let (mut scenario, version, mut pool, admin_cap, clock, tester) = setup_test_environment<
        SUI,
        USDC,
    >();

    admin::set_flash_loan_fee_rate<SUI, USDC>(
        &admin_cap,
        &mut pool,
        1,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    let r0 = test_scenario::next_tx(&mut scenario, tester);
    assert!(pool::flash_loan_fee_rate(&pool) == 1);
    assert!(r0.num_user_events() == 1);

    admin::set_flash_loan_fee_rate<SUI, USDC>(
        &admin_cap,
        &mut pool,
        999999,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    test_scenario::next_tx(&mut scenario, tester);
    assert!(pool::flash_loan_fee_rate(&pool) == 999999);

    cleanup_test_environment(scenario, version, pool, admin_cap, clock);
}

#[test]
#[expected_failure(abort_code = 1, location = mmt_v3::admin)]
public fun set_negative_flash_loan_swap_fee_0() {
    let (mut scenario, version, mut pool, admin_cap, clock, _) = setup_test_environment<
        SUI,
        USDC,
    >();

    admin::set_flash_loan_fee_rate<SUI, USDC>(
        &admin_cap,
        &mut pool,
        0,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    cleanup_test_environment(scenario, version, pool, admin_cap, clock);
}

#[test]
#[expected_failure(abort_code = 1, location = mmt_v3::admin)]
public fun set_negative_flash_loan_swap_fee_1000000() {
    let (mut scenario, version, mut pool, admin_cap, clock, _) = setup_test_environment<
        SUI,
        USDC,
    >();

    admin::set_flash_loan_fee_rate<SUI, USDC>(
        &admin_cap,
        &mut pool,
        1000000,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    cleanup_test_environment(scenario, version, pool, admin_cap, clock);
}

#[test]
public fun swap_fee() {
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
    transfer::public_transfer(position, tester);
    test_scenario::next_tx(&mut scenario, tester);

    admin::set_swap_fee_rate<SUI, USDC>(
        &admin_cap,
        &mut pool,
        500, // 0.05%
        &version,
        test_scenario::ctx(&mut scenario),
    );

    assert!(pool::swap_fee_rate<SUI, USDC>(&pool) == 500);

    test_scenario::next_tx(&mut scenario, tester);

    // Perform flash swaps to test fee collection
    perform_flash_swap<SUI, USDC>(
        &mut pool,
        &clock,
        &version,
        &mut scenario,
        false,
        1000 * USDC_DECIMALS,
        DEFAULT_UPPER_TICK,
    );
    perform_flash_swap<SUI, USDC>(
        &mut pool,
        &clock,
        &version,
        &mut scenario,
        true,
        1000 * SUI_DECIMALS,
        42999940923,
    );

    cleanup_test_environment(scenario, version, pool, admin_cap, clock);
}

#[test]
#[expected_failure(abort_code = 1, location = mmt_v3::admin)]
public fun set_negative_swap_fee_0() {
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
    transfer::public_transfer(position, tester);
    test_scenario::next_tx(&mut scenario, tester);

    admin::set_swap_fee_rate<SUI, USDC>(
        &admin_cap,
        &mut pool,
        0,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    cleanup_test_environment(scenario, version, pool, admin_cap, clock);
}

#[test]
#[expected_failure(abort_code = 1, location = mmt_v3::admin)]
public fun set_negative_swap_fee_1000000() {
    let (mut scenario, version, mut pool, admin_cap, clock, _) = setup_test_environment<
        SUI,
        USDC,
    >();

    admin::set_swap_fee_rate<SUI, USDC>(
        &admin_cap,
        &mut pool,
        1000000,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    cleanup_test_environment(scenario, version, pool, admin_cap, clock);
}

#[test]
public fun test_increase_observation_cardinality_next() {
    let (mut scenario, version, mut pool, admin_cap, clock, _) = setup_test_environment<
        SUI,
        USDC,
    >();

    admin::increase_observation_cardinality_next<SUI, USDC>(
        &admin_cap,
        &mut pool,
        100,
        test_scenario::ctx(&mut scenario),
    );

    cleanup_test_environment(scenario, version, pool, admin_cap, clock);
}

#[test]
public fun test_toggle_trading() {
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
    transfer::public_transfer(position, tester);
    test_scenario::next_tx(&mut scenario, tester);

    let admin_cap_for_toggle = app::create_for_testing(test_scenario::ctx(&mut scenario));

    admin::toggle_trading<SUI, USDC>(
        &admin_cap_for_toggle,
        &mut pool,
        false,
        test_scenario::ctx(&mut scenario),
    );

    let result = test_scenario::next_tx(&mut scenario, tester);
    assert!(result.num_user_events() == 1);

    admin::toggle_trading<SUI, USDC>(
        &admin_cap_for_toggle,
        &mut pool,
        true,
        test_scenario::ctx(&mut scenario),
    );

    app::destroy_for_testing(admin_cap_for_toggle);

    perform_flash_swap<SUI, USDC>(
        &mut pool,
        &clock,
        &version,
        &mut scenario,
        false,
        1000 * USDC_DECIMALS,
        DEFAULT_UPPER_TICK,
    );

    cleanup_test_environment(scenario, version, pool, admin_cap, clock);
}

#[test, expected_failure]
public fun initialize_pool_reward_invalid_timestamp() {
    let (mut scenario, version, mut pool, admin_cap, clock, tester) = setup_test_environment<
        SUI,
        USDC,
    >();

    test_scenario::next_tx(&mut scenario, tester);
    let acl = app::create_acl_for_testing(test_scenario::ctx(&mut scenario));
    let now = utils::to_seconds(clock::timestamp_ms(&clock));
    admin::initialize_pool_reward<SUI, USDC, USDC>(
        &acl,
        &mut pool,
        now,
        3600,
        balance::create_for_testing<USDC>(1),
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    app::destroy_acl_for_testing(acl);
    cleanup_test_environment(scenario, version, pool, admin_cap, clock);
}

#[test, expected_failure]
public fun not_authorised_pool_admin_paths() {
    let (mut scenario, version, mut pool, admin_cap, clock, tester) = setup_test_environment<
        SUI,
        USDC,
    >();

    let b = @0xBB;
    test_scenario::next_tx(&mut scenario, tester);

    let acl = app::create_acl_for_testing(test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, b);

    admin::set_swap_fee_rate<SUI, USDC>(
        &acl,
        &mut pool,
        500,
        &version,
        test_scenario::ctx(&mut scenario),
    );
    app::destroy_acl_for_testing(acl);
    cleanup_test_environment(scenario, version, pool, admin_cap, clock);
}

#[test, expected_failure]
public fun not_authorised_rewarder_admin_paths() {
    let (mut scenario, version, mut pool, admin_cap, clock, _) = setup_test_environment<
        SUI,
        USDC,
    >();

    let b = @0xBB;
    let acl = app::create_acl_for_testing(test_scenario::ctx(&mut scenario));

    let start = utils::to_seconds(clock::timestamp_ms(&clock)) + 60;
    test_scenario::next_tx(&mut scenario, b);

    admin::initialize_pool_reward<SUI, USDC, USDC>(
        &acl,
        &mut pool,
        start,
        3600,
        balance::create_for_testing<USDC>(1),
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );
    app::destroy_acl_for_testing(acl);
    cleanup_test_environment(scenario, version, pool, admin_cap, clock);
}

#[test]
public fun collect_protocol_fee_edges() {
    let (mut scenario, version, mut pool, admin_cap, clock, tester) = setup_test_environment<
        SUI,
        USDC,
    >();
    let acl = app::create_acl_for_testing(test_scenario::ctx(&mut scenario));

    let (balance_x, balance_y, receipt) = trade::flash_swap<SUI, USDC>(
        &mut pool,
        false,
        true,
        500 * USDC_DECIMALS,
        611809286962066560,
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );
    balance_x.destroy_for_testing();
    balance_y.destroy_for_testing();

    let (pay_x, pay_y) = trade::swap_receipt_debts(&receipt);
    trade::repay_flash_swap<SUI, USDC>(
        &mut pool,
        receipt,
        balance::create_for_testing<SUI>(pay_x),
        balance::create_for_testing<USDC>(pay_y),
        &version,
        test_scenario::ctx(&mut scenario),
    );
    test_scenario::next_tx(&mut scenario, tester);

    let (bx0, by0) = admin::collect_protocol_fee<SUI, USDC>(
        &acl,
        &mut pool,
        0,
        0,
        &version,
        test_scenario::ctx(&mut scenario),
    );
    let res0 = test_scenario::next_tx(&mut scenario, tester);
    assert!(bx0.value() == 0 && by0.value() == 0);
    bx0.destroy_for_testing();
    by0.destroy_for_testing();
    assert!(res0.num_user_events() == 1);

    let want = 1u64 << 60;
    let before_x = pool::protocol_fee_x(&pool);
    let before_y = pool::protocol_fee_y(&pool);
    let (bx1, by1) = admin::collect_protocol_fee<SUI, USDC>(
        &acl,
        &mut pool,
        want,
        want,
        &version,
        test_scenario::ctx(&mut scenario),
    );
    test_scenario::next_tx(&mut scenario, tester);
    assert!(bx1.value() == before_x && by1.value() == before_y);
    bx1.destroy_for_testing();
    by1.destroy_for_testing();

    app::destroy_acl_for_testing(acl);
    cleanup_test_environment(scenario, version, pool, admin_cap, clock);
}
