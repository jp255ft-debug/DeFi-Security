#[test_only]
module mmt_v3::create_pool_tests;

use mmt_v3::admin;
use mmt_v3::app;
use mmt_v3::collect;
use mmt_v3::constants;
use mmt_v3::global_config;
use mmt_v3::liquidity;
use mmt_v3::pool;
use mmt_v3::position;
use mmt_v3::test_helper::{Self as th, USDC, USDT, create_pool_, add_liquidity_};
use mmt_v3::tick_math;
use mmt_v3::trade;
use mmt_v3::utils;
use mmt_v3::version;
use sui::balance;
use sui::clock;
use sui::coin;
use sui::sui::SUI;
use sui::test_scenario;

const SUI_DECIMALS: u64 = 1_000_000_000;
const USDC_DECIMALS: u64 = 1_000_000;

#[test]
public fun create_pool() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    th::setup(test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);

    create_pool_<SUI, USDC>(100, 583337266871351588, true, &version, &mut scenario);
    test_scenario::next_tx(&mut scenario, tester1);
    let pool = th::take_pool<SUI, USDC>(&mut scenario);
    assert!(pool::protocol_fee_share<SUI, USDC>(&pool) == constants::protocol_swap_fee_share());
    assert!(
        pool::protocol_flash_loan_fee_share<SUI, USDC>(&pool) == constants::protocol_flash_loan_fee_share()
    );
    assert!(pool.flash_loan_fee_rate<SUI, USDC>() == 100);
    version::destroy_version_for_testing(version);
    th::return_pool<SUI, USDC>(pool);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = 29, location = mmt_v3::global_config)]
public fun create_pool_negative() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    th::setup(test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);

    create_pool_<SUI, USDC>(101, 583337266871351588, true, &version, &mut scenario);
    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = 71, location = mmt_v3::create_pool)]
public fun create_pool_negative_same_token_type() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    th::setup(test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);

    create_pool_<SUI, SUI>(100, 583337266871351588, true, &version, &mut scenario);
    version::destroy_version_for_testing(version);

    test_scenario::end(scenario);
}

#[test]
public fun create_pool_same_token_module() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    th::setup(test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);

    create_pool_<USDC, USDT>(100, 583337266871351588, false, &version, &mut scenario);
    version::destroy_version_for_testing(version);

    test_scenario::end(scenario);
}

#[test]
public fun enable_fee_rate() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);

    th::setup(test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);

    let mut config = th::take_config(&mut scenario);
    let admin = app::create_for_testing(test_scenario::ctx(&mut scenario));
    global_config::enable_fee_rate(
        &admin,
        &mut config,
        20000,
        400,
        test_scenario::ctx(&mut scenario),
    );

    let tx_result = test_scenario::next_tx(&mut scenario, tester1);
    assert!(tx_result.num_user_events() == 1);

    app::destroy_for_testing(admin);
    th::return_config(config);
    test_scenario::end(scenario);
}

#[test]
public fun add_liquidity() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));
    create_pool_<SUI, USDC>(
        100,
        583337266871351588,
        true,
        &version,
        &mut scenario,
    );

    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);
    let clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));
    let lower_tick = tick_math::get_tick_at_sqrt_price(553402322211286548); // lower price 1.0
    let upper_tick = tick_math::get_tick_at_sqrt_price(611809286962066562); // upper price 1.1
    let (_, _, position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 100 sui
        1000, // 100 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );
    transfer::public_transfer(position, tester1);
    clock::destroy_for_testing(clock);
    th::return_pool<SUI, USDC>(pool);
    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = 72, location = mmt_v3::tick)]
public fun add_liquidity_negative_invalid_tick_range() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        100,
        583337266871351588,
        true,
        &version,
        &mut scenario,
    );

    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);
    let min_tick_range_factor = pool::min_tick_range_factor<SUI, USDC>(&pool);
    assert!(min_tick_range_factor == 1);

    let clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));

    let acl = app::create_acl_for_testing(test_scenario::ctx(&mut scenario));
    pool::set_min_tick_range_factor(
        &acl,
        &mut pool,
        5,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    let min_tick_range_factor = pool::min_tick_range_factor<SUI, USDC>(&pool);
    assert!(min_tick_range_factor == 5);

    let lower_tick = mmt_v3::i32::from(20);
    let upper_tick = mmt_v3::i32::from(28);
    let (_, _, position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 100 sui
        1000, // 100 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );

    transfer::public_transfer(position, tester1);
    clock::destroy_for_testing(clock);
    th::return_pool<SUI, USDC>(pool);
    version::destroy_version_for_testing(version);
    app::destroy_acl_for_testing(acl);
    test_scenario::end(scenario);
}

#[test]
public fun add_liquidity_positive_default_min_tick_range_factor() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        100,
        583337266871351588,
        true,
        &version,
        &mut scenario,
    );

    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);
    let clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));

    let min_tick_range_factor = pool::min_tick_range_factor<SUI, USDC>(&pool);
    assert!(min_tick_range_factor == 1);

    let lower_tick = mmt_v3::i32::from(20);
    let upper_tick = mmt_v3::i32::from(22);
    let (_, _, position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 100 sui
        1000, // 100 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );
    transfer::public_transfer(position, tester1);
    clock::destroy_for_testing(clock);
    th::return_pool<SUI, USDC>(pool);
    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = 73, location = mmt_v3::pool)]
public fun set_nagetive_min_tick_range_factor_0() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        100,
        583337266871351588,
        true,
        &version,
        &mut scenario,
    );

    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);

    let acl = app::create_acl_for_testing(test_scenario::ctx(&mut scenario));
    pool::set_min_tick_range_factor(
        &acl,
        &mut pool,
        0,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    th::return_pool<SUI, USDC>(pool);
    app::destroy_acl_for_testing(acl);
    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = 73, location = mmt_v3::pool)]
public fun set_nagetive_min_tick_range_factor_100() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        100,
        583337266871351588,
        true,
        &version,
        &mut scenario,
    );

    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);

    let acl = app::create_acl_for_testing(test_scenario::ctx(&mut scenario));
    pool::set_min_tick_range_factor(
        &acl,
        &mut pool,
        100,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    th::return_pool<SUI, USDC>(pool);
    app::destroy_acl_for_testing(acl);
    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
public fun add_liquidity_positive_valid_tick_range() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        100,
        583337266871351588,
        true,
        &version,
        &mut scenario,
    );

    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);
    let clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));

    let acl = app::create_acl_for_testing(test_scenario::ctx(&mut scenario));
    pool::set_min_tick_range_factor(
        &acl,
        &mut pool,
        5,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    let min_tick_range_factor = pool::min_tick_range_factor<SUI, USDC>(&pool);
    assert!(min_tick_range_factor == 5);

    let lower_tick = mmt_v3::i32::from(20);
    let upper_tick = mmt_v3::i32::from(30);
    let (_, _, position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 100 sui
        1000, // 100 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );
    transfer::public_transfer(position, tester1);
    clock::destroy_for_testing(clock);
    th::return_pool<SUI, USDC>(pool);
    version::destroy_version_for_testing(version);
    app::destroy_acl_for_testing(acl);
    test_scenario::end(scenario);
}

#[test]
public fun add_liquidity_single_sided_b() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        3000,
        553402322211286548, // price 0.9
        true,
        &version,
        &mut scenario,
    );

    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);
    let clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));
    let lower_tick = tick_math::get_tick_at_sqrt_price(521752713013311288); // lower price 0.8
    let upper_tick = tick_math::get_tick_at_sqrt_price(583337266871351588); // upper price 1
    let _lower_tick_1 = tick_math::get_tick_at_sqrt_price(553402322211286548); // lower price 0.9
    let _upper_tick_1 = tick_math::get_tick_at_sqrt_price(611809286962066562); // upper price 1.1
    let (_, _, position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 100 sui
        1000, // 100 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );

    test_scenario::next_tx(&mut scenario, tester1);
    let (swap_amount, _) = trade::get_optimal_swap_amount_for_single_sided_liquidity<SUI, USDC>(
        &pool,
        10 * USDC_DECIMALS,
        &position,
        79226673515401279992447579050,
        false,
        20,
    );
    assert!(swap_amount == 4853409);
    let (balance_x, balance_y, swap_receipt) = trade::flash_swap<SUI, USDC>(
        &mut pool,
        false, // is x 2 y
        true,
        swap_amount,
        79226673515401279992447579050, // 1.0 sqrt price limit
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );
    let (pay_x, pay_y) = trade::swap_receipt_debts(&swap_receipt);
    trade::repay_flash_swap<SUI, USDC>(
        &mut pool,
        swap_receipt,
        balance::create_for_testing<SUI>(pay_x),
        balance::create_for_testing<USDC>(pay_y),
        &version,
        test_scenario::ctx(&mut scenario),
    );

    let sui_amount = balance::value(&balance_x);
    transfer::public_transfer(position, tester1);

    let remaining_usdc_amount = 10 * USDC_DECIMALS - swap_amount;
    let (_, _, position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        sui_amount / SUI_DECIMALS,
        remaining_usdc_amount / USDC_DECIMALS,
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );

    balance::destroy_for_testing<SUI>(balance_x);
    balance::destroy_for_testing<USDC>(balance_y);
    clock::destroy_for_testing(clock);
    transfer::public_transfer(position, tester1);
    th::return_pool<SUI, USDC>(pool);
    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
public fun add_liquidity_single_sided_a() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        3000,
        553402322211286548, // price 0.8
        true,
        &version,
        &mut scenario,
    );

    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);

    let lower_tick = tick_math::get_tick_at_sqrt_price(521752713013311288); // lower price 0.8
    let upper_tick = tick_math::get_tick_at_sqrt_price(583337266871351588); // upper price 1
    let _lower_tick_1 = tick_math::get_tick_at_sqrt_price(553402322211286548); // lower price 0.9
    let _upper_tick_1 = tick_math::get_tick_at_sqrt_price(611809286962066562); // upper price 1.1
    let clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));
    let (_, _, position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 100 sui
        1000, // 100 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );

    test_scenario::next_tx(&mut scenario, tester1);
    let (swap_amount, fix_a) = trade::get_optimal_swap_amount_for_single_sided_liquidity<SUI, USDC>(
        &pool,
        10 * SUI_DECIMALS,
        &position,
        4295048076,
        true,
        20,
    );
    let (balance_x, balance_y, swap_receipt) = trade::flash_swap<SUI, USDC>(
        &mut pool,
        true, // is x 2 y
        true,
        swap_amount,
        4295048076, // 1.0 sqrt price limit
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );
    let (pay_x, pay_y) = trade::swap_receipt_debts(&swap_receipt);
    trade::repay_flash_swap<SUI, USDC>(
        &mut pool,
        swap_receipt,
        balance::create_for_testing<SUI>(pay_x),
        balance::create_for_testing<USDC>(pay_y),
        &version,
        test_scenario::ctx(&mut scenario),
    );

    let usdc_amount = balance::value(&balance_y);
    transfer::public_transfer(position, tester1);

    let remaining_sui_amount = 10 * SUI_DECIMALS - swap_amount;
    let (_, _, position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        remaining_sui_amount / SUI_DECIMALS,
        usdc_amount / USDC_DECIMALS,
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );

    balance::destroy_for_testing<SUI>(balance_x);
    balance::destroy_for_testing<USDC>(balance_y);
    clock::destroy_for_testing(clock);
    transfer::public_transfer(position, tester1);
    th::return_pool<SUI, USDC>(pool);
    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = 70, location = mmt_v3::pool)]
public fun pause_add_liquidity_negative() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        3000,
        553402322211286548, // price 0.8
        true,
        &version,
        &mut scenario,
    );

    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);

    let lower_tick = tick_math::get_tick_at_sqrt_price(521752713013311288); // lower price 0.8
    let upper_tick = tick_math::get_tick_at_sqrt_price(583337266871351588); // upper price 1
    let _lower_tick_1 = tick_math::get_tick_at_sqrt_price(553402322211286548); // lower price 0.9
    let _upper_tick_1 = tick_math::get_tick_at_sqrt_price(611809286962066562); // upper price 1.1
    let clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));
    let (_, _, position1) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 100 sui
        1000, // 100 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );

    test_scenario::next_tx(&mut scenario, tester1);
    let acl = app::create_acl_for_testing(test_scenario::ctx(&mut scenario));

    pool::pause(&acl, &mut pool, true, test_scenario::ctx(&mut scenario));

    let (_, _, position2) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 100 sui
        1000, // 100 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );

    clock::destroy_for_testing(clock);
    app::destroy_acl_for_testing(acl);
    transfer::public_transfer(position1, tester1);
    transfer::public_transfer(position2, tester1);
    th::return_pool<SUI, USDC>(pool);
    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
public fun pause_add_liquidity_positive() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        3000,
        553402322211286548, // price 0.8
        true,
        &version,
        &mut scenario,
    );

    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);

    let lower_tick = tick_math::get_tick_at_sqrt_price(521752713013311288); // lower price 0.8
    let upper_tick = tick_math::get_tick_at_sqrt_price(583337266871351588); // upper price 1
    let _lower_tick_1 = tick_math::get_tick_at_sqrt_price(553402322211286548); // lower price 0.9
    let _upper_tick_1 = tick_math::get_tick_at_sqrt_price(611809286962066562); // upper price 1.1
    let clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));
    let (_, _, position1) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 100 sui
        1000, // 100 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );

    test_scenario::next_tx(&mut scenario, tester1);
    let acl = app::create_acl_for_testing(test_scenario::ctx(&mut scenario));

    pool::pause(&acl, &mut pool, false, test_scenario::ctx(&mut scenario));

    let tx_result = scenario.next_tx(tester1);
    assert!(tx_result.num_user_events() == 1);

    let (_, _, position2) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 100 sui
        1000, // 100 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );

    clock::destroy_for_testing(clock);
    app::destroy_acl_for_testing(acl);
    transfer::public_transfer(position1, tester1);
    transfer::public_transfer(position2, tester1);
    th::return_pool<SUI, USDC>(pool);
    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
public fun remove_liquidity() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        100, // fee rate
        583337266871351588, // init price
        true,
        &version,
        &mut scenario,
    );

    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);
    let clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));
    let lower_tick = tick_math::get_tick_at_sqrt_price(553402322211286548); // lower price 1.0
    let upper_tick = tick_math::get_tick_at_sqrt_price(611809286962066562); // upper price 1.1

    let (refund_x_amt, refund_y_amt, position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        100, // 100 sui
        100, // 100 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );
    transfer::public_transfer(position, tester1);

    test_scenario::next_tx(&mut scenario, tester1);
    let mut position = th::take_position(&mut scenario, tester1);

    let liquidity = position::liquidity(&position);
    assert!(pool::liquidity(&pool) == liquidity);
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

    let amt_a = coin::burn_for_testing<SUI>(asset_a);
    let amt_b = coin::burn_for_testing<USDC>(asset_b);

    assert!(amt_a == 100 * SUI_DECIMALS - refund_x_amt - 1); // -1 for adjusting round down error
    assert!(amt_b == 100 * USDC_DECIMALS - refund_y_amt - 1);

    clock::destroy_for_testing(clock);
    th::return_position(position, tester1);
    th::return_pool<SUI, USDC>(pool);
    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
public fun remove_liquidity_new() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        100, // fee rate
        583337266871351588, // init price 1
        true,
        &version,
        &mut scenario,
    );

    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);

    let lower_tick = tick_math::get_tick_at_sqrt_price(4295048076); // lower price 1.0
    let upper_tick = tick_math::get_tick_at_sqrt_price(79226673515401279992447579050); // upper price 1.1

    let clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));
    let (refund_x_amt, refund_y_amt, position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        100, // 100 sui
        100, // 100 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );
    transfer::public_transfer(position, tester1);

    test_scenario::next_tx(&mut scenario, tester1);
    let mut position = th::take_position(&mut scenario, tester1);

    let liquidity = position::liquidity(&position);
    assert!(pool::liquidity(&pool) == liquidity);
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

    let amt_a = coin::burn_for_testing<SUI>(asset_a);
    let amt_b = coin::burn_for_testing<USDC>(asset_b);

    assert!(amt_a == 100 * SUI_DECIMALS - refund_x_amt - 1); // -1 for adjusting round down error
    assert!(amt_b == 100 * USDC_DECIMALS - refund_y_amt - 1);

    clock::destroy_for_testing(clock);
    th::return_position(position, tester1);
    th::return_pool<SUI, USDC>(pool);
    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = 10, location = mmt_v3::liquidity_math)]
public fun remove_lp_more_liquidity() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        100, // fee rate
        583337266871351588, // init price
        true,
        &version,
        &mut scenario,
    );

    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);

    let lower_tick = tick_math::get_tick_at_sqrt_price(553402322211286548); // lower price 1.0
    let upper_tick = tick_math::get_tick_at_sqrt_price(611809286962066562); // upper price 1.1
    let clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));

    let (refund_x_amt, refund_y_amt, position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        100, // 100 sui
        100, // 100 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );
    transfer::public_transfer(position, tester1);

    test_scenario::next_tx(&mut scenario, tester1);
    let mut position = th::take_position(&mut scenario, tester1);

    let liquidity = position::liquidity(&position);
    assert!(pool::liquidity(&pool) == liquidity);

    let liquidity = position::liquidity(&position);
    let (asset_a, asset_b) = liquidity::remove_liquidity<SUI, USDC>(
        &mut pool,
        &mut position,
        liquidity + 1,
        0,
        0,
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    let amt_a = coin::burn_for_testing<SUI>(asset_a);
    let amt_b = coin::burn_for_testing<USDC>(asset_b);

    assert!(amt_a == 100 * SUI_DECIMALS - refund_x_amt);
    assert!(amt_b == 100 * USDC_DECIMALS - refund_y_amt);

    clock::destroy_for_testing(clock);
    th::return_position(position, tester1);
    th::return_pool<SUI, USDC>(pool);
    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = 7, location = mmt_v3::trade)]
public fun swap_negative() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        100,
        583337266871351588,
        true,
        &version,
        &mut scenario,
    );

    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);
    let clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));
    let (balance_x, balance_y, swap_receipt) = trade::flash_swap<SUI, USDC>(
        &mut pool,
        true,
        true,
        10 * USDC_DECIMALS,
        79226673515401279992,
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    balance::destroy_for_testing<SUI>(balance_x);
    balance::destroy_for_testing<USDC>(balance_y);
    let (pay_x, pay_y) = trade::swap_receipt_debts(&swap_receipt);
    trade::repay_flash_swap<SUI, USDC>(
        &mut pool,
        swap_receipt,
        balance::create_for_testing<SUI>(pay_x),
        balance::create_for_testing<USDC>(pay_y),
        &version,
        test_scenario::ctx(&mut scenario),
    );
    th::return_pool<SUI, USDC>(pool);
    clock::destroy_for_testing(clock);
    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = 31, location = mmt_v3::trade)]
public fun swap_uninitialised_pool() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        100,
        583337266871351588,
        false, // dont initialise pool
        &version,
        &mut scenario,
    );

    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);
    let clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));
    let (balance_x, balance_y, swap_receipt) = trade::flash_swap<SUI, USDC>(
        &mut pool,
        true,
        true,
        10 * USDC_DECIMALS,
        79226673515401279992,
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    balance::destroy_for_testing<SUI>(balance_x);
    balance::destroy_for_testing<USDC>(balance_y);
    let (pay_x, pay_y) = trade::swap_receipt_debts(&swap_receipt);
    trade::repay_flash_swap<SUI, USDC>(
        &mut pool,
        swap_receipt,
        balance::create_for_testing<SUI>(pay_x),
        balance::create_for_testing<USDC>(pay_y),
        &version,
        test_scenario::ctx(&mut scenario),
    );
    th::return_pool<SUI, USDC>(pool);
    clock::destroy_for_testing(clock);
    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = 7, location = mmt_v3::trade)]
public fun initialise_out_rage_and_swap() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        100, // fee_rate
        597742825358017408, // sqrt price 1.05
        true,
        &version,
        &mut scenario,
    );
    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);

    let lower_tick = tick_math::get_tick_at_sqrt_price(368934881474191032); // lower price 0.4
    let upper_tick = tick_math::get_tick_at_sqrt_price(412481737123559485); // upper price 0.5

    let clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));
    let (_, _, position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 1000 sui
        1000, // 1000 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );
    transfer::public_transfer(position, tester1);
    test_scenario::next_tx(&mut scenario, tester1);
    let (balance_x, balance_y, swap_receipt) = trade::flash_swap<SUI, USDC>(
        &mut pool,
        false, // is x 2 y
        true,
        1000 * USDC_DECIMALS,
        451851103962979245, // 1.1 sqrt price limit
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    balance::destroy_for_testing<SUI>(balance_x);
    balance::destroy_for_testing<USDC>(balance_y);
    let (pay_x, pay_y) = trade::swap_receipt_debts(&swap_receipt);
    trade::repay_flash_swap<SUI, USDC>(
        &mut pool,
        swap_receipt,
        balance::create_for_testing<SUI>(pay_x),
        balance::create_for_testing<USDC>(pay_y),
        &version,
        test_scenario::ctx(&mut scenario),
    );
    th::return_pool<SUI, USDC>(pool);
    clock::destroy_for_testing(clock);
    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = 7, location = mmt_v3::trade)]
public fun swap_more_than_pool_liquidity() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        100, // fee_rate
        597742825358017408, // sqrt price 1.05
        true,
        &version,
        &mut scenario,
    );
    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);
    let clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));

    let lower_tick = tick_math::get_tick_at_sqrt_price(583337266871351552); // lower price 1.0
    let upper_tick = tick_math::get_tick_at_sqrt_price(611809286962066560); // upper price 1.1
    let (_, _, position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 1000 sui
        1000, // 1000 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );
    transfer::public_transfer(position, tester1);
    test_scenario::next_tx(&mut scenario, tester1);
    let (balance_x, balance_y, swap_receipt) = trade::flash_swap<SUI, USDC>(
        &mut pool,
        false, // is x 2 y
        true,
        1000 * USDC_DECIMALS,
        583337266871351552, // 1.1 sqrt price limit
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    balance::destroy_for_testing<SUI>(balance_x);
    balance::destroy_for_testing<USDC>(balance_y);
    let (pay_x, pay_y) = trade::swap_receipt_debts(&swap_receipt);
    trade::repay_flash_swap<SUI, USDC>(
        &mut pool,
        swap_receipt,
        balance::create_for_testing<SUI>(pay_x),
        balance::create_for_testing<USDC>(pay_y),
        &version,
        test_scenario::ctx(&mut scenario),
    );
    th::return_pool<SUI, USDC>(pool);
    clock::destroy_for_testing(clock);
    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = 8, location = mmt_v3::trade)]
public fun swap_nagetive_sqrt_price_limit() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        100, // fee_rate
        597742825358017408, // sqrt price 1.05
        true,
        &version,
        &mut scenario,
    );
    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);
    let clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));

    let lower_tick = tick_math::get_tick_at_sqrt_price(583337266871351552); // lower price 1.0
    let upper_tick = tick_math::get_tick_at_sqrt_price(611809286962066560); // upper price 1.1
    let (_, _, position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 1000 sui
        1000, // 1000 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );
    transfer::public_transfer(position, tester1);
    test_scenario::next_tx(&mut scenario, tester1);
    let (balance_x, balance_y, swap_receipt) = trade::flash_swap<SUI, USDC>(
        &mut pool,
        true,
        true,
        10 * USDC_DECIMALS,
        4295048015, // negative sqrt price limit
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    balance::destroy_for_testing<SUI>(balance_x);
    balance::destroy_for_testing<USDC>(balance_y);
    let (pay_x, pay_y) = trade::swap_receipt_debts(&swap_receipt);
    trade::repay_flash_swap<SUI, USDC>(
        &mut pool,
        swap_receipt,
        balance::create_for_testing<SUI>(pay_x),
        balance::create_for_testing<USDC>(pay_y),
        &version,
        test_scenario::ctx(&mut scenario),
    );
    th::return_pool<SUI, USDC>(pool);
    clock::destroy_for_testing(clock);
    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = 8, location = mmt_v3::trade)]
public fun swap_nagetive_sqrt_price_limit_max() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        100, // fee_rate
        597742825358017408, // sqrt price 1.05
        true,
        &version,
        &mut scenario,
    );
    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);
    let clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));

    let lower_tick = tick_math::get_tick_at_sqrt_price(583337266871351552); // lower price 1.0
    let upper_tick = tick_math::get_tick_at_sqrt_price(611809286962066560); // upper price 1.1
    let (_, _, position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 1000 sui
        1000, // 1000 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );
    transfer::public_transfer(position, tester1);
    test_scenario::next_tx(&mut scenario, tester1);
    let (balance_x, balance_y, swap_receipt) = trade::flash_swap<SUI, USDC>(
        &mut pool,
        false,
        true,
        10 * USDC_DECIMALS,
        79226673515401279992447579056, // negative sqrt price limit
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    balance::destroy_for_testing<SUI>(balance_x);
    balance::destroy_for_testing<USDC>(balance_y);
    let (pay_x, pay_y) = trade::swap_receipt_debts(&swap_receipt);
    trade::repay_flash_swap<SUI, USDC>(
        &mut pool,
        swap_receipt,
        balance::create_for_testing<SUI>(pay_x),
        balance::create_for_testing<USDC>(pay_y),
        &version,
        test_scenario::ctx(&mut scenario),
    );
    th::return_pool<SUI, USDC>(pool);
    clock::destroy_for_testing(clock);
    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = 7, location = mmt_v3::trade)]
public fun add_lp_discrete_and_swap() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        100, // fee_rate
        597742825358017408, // sqrt price 1.05
        true,
        &version,
        &mut scenario,
    );
    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);
    let clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));

    let lower_tick = tick_math::get_tick_at_sqrt_price(583337266871351552); // lower price 1.0
    let upper_tick = tick_math::get_tick_at_sqrt_price(611809286962066560); // upper price 1.1
    let (_, _, position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 1000 sui
        1000, // 1000 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );
    transfer::public_transfer(position, tester1);

    test_scenario::next_tx(&mut scenario, tester1);
    let (balance_x, balance_y, swap_receipt) = trade::flash_swap<SUI, USDC>(
        &mut pool,
        false, // is x 2 y
        true,
        1000000 * USDC_DECIMALS,
        583337266871351552, // 0.6
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    balance::destroy_for_testing<SUI>(balance_x);
    balance::destroy_for_testing<USDC>(balance_y);
    let (pay_x, pay_y) = trade::swap_receipt_debts(&swap_receipt);
    trade::repay_flash_swap<SUI, USDC>(
        &mut pool,
        swap_receipt,
        balance::create_for_testing<SUI>(pay_x),
        balance::create_for_testing<USDC>(pay_y),
        &version,
        test_scenario::ctx(&mut scenario),
    );

    test_scenario::next_tx(&mut scenario, tester1);
    let lower_tick = tick_math::get_tick_at_sqrt_price(451851103962979245); // lower price 0.6
    let upper_tick = tick_math::get_tick_at_sqrt_price(488054973178900129); // upper price 0.7
    let (_, _, position1) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 1000 sui
        1000, // 1000 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );
    transfer::public_transfer(position1, tester1);
    th::return_pool<SUI, USDC>(pool);
    clock::destroy_for_testing(clock);
    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
public fun oracle() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        100, // fee_rate
        597742825358017408, // sqrt price 1.05
        true,
        &version,
        &mut scenario,
    );
    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);
    let admin_cap = app::create_acl_for_testing(test_scenario::ctx(&mut scenario));
    admin::increase_observation_cardinality_next(
        &admin_cap,
        &mut pool,
        10,
        test_scenario::ctx(&mut scenario),
    );
    let lower_tick = tick_math::get_tick_at_sqrt_price(583337266871351552); // lower price 1.0
    let upper_tick = tick_math::get_tick_at_sqrt_price(611809286962066560); // upper price 1.1
    let clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));
    let (_, _, position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 1000 sui
        1000, // 1000 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );
    transfer::public_transfer(position, tester1);

    test_scenario::next_tx(&mut scenario, tester1);
    let (balance_x, balance_y, swap_receipt) = trade::flash_swap<SUI, USDC>(
        &mut pool,
        false, // is x 2 y
        true,
        1000 * USDC_DECIMALS,
        611809286962066560, // 1.1 sqrt price limit
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );
    balance::destroy_for_testing<SUI>(balance_x);
    balance::destroy_for_testing<USDC>(balance_y);

    let (pay_x, pay_y) = trade::swap_receipt_debts(&swap_receipt);
    trade::repay_flash_swap<SUI, USDC>(
        &mut pool,
        swap_receipt,
        balance::create_for_testing<SUI>(pay_x),
        balance::create_for_testing<USDC>(pay_y),
        &version,
        test_scenario::ctx(&mut scenario),
    );

    test_scenario::next_tx(&mut scenario, tester1);
    let (res, res1) = pool::observe<SUI, USDC>(
        &pool,
        vector::singleton(clock::timestamp_ms(&clock)),
        &clock,
    );

    th::return_pool<SUI, USDC>(pool);
    version::destroy_version_for_testing(version);
    clock::destroy_for_testing(clock);
    app::destroy_acl_for_testing(admin_cap);
    test_scenario::end(scenario);
}

#[test]
public fun oracle_wwithout_increase_observation() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        100, // fee_rate
        597742825358017408, // sqrt price 1.05
        true,
        &version,
        &mut scenario,
    );
    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);
    let admin_cap = app::create_acl_for_testing(test_scenario::ctx(&mut scenario));
    let lower_tick = tick_math::get_tick_at_sqrt_price(583337266871351552); // lower price 1.0
    let upper_tick = tick_math::get_tick_at_sqrt_price(611809286962066560); // upper price 1.1
    let clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));
    let (_, _, position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 1000 sui
        1000, // 1000 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );
    transfer::public_transfer(position, tester1);

    test_scenario::next_tx(&mut scenario, tester1);
    assert!(pool::observation_index(&pool) == 0);
    let (balance_x, balance_y, swap_receipt) = trade::flash_swap<SUI, USDC>(
        &mut pool,
        false, // is x 2 y
        true,
        1000 * USDC_DECIMALS,
        611809286962066560, // 1.1 sqrt price limit
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );
    balance::destroy_for_testing<SUI>(balance_x);
    balance::destroy_for_testing<USDC>(balance_y);

    let (pay_x, pay_y) = trade::swap_receipt_debts(&swap_receipt);
    trade::repay_flash_swap<SUI, USDC>(
        &mut pool,
        swap_receipt,
        balance::create_for_testing<SUI>(pay_x),
        balance::create_for_testing<USDC>(pay_y),
        &version,
        test_scenario::ctx(&mut scenario),
    );

    test_scenario::next_tx(&mut scenario, tester1);
    pool::observe<SUI, USDC>(&pool, vector::singleton(clock::timestamp_ms(&clock)), &clock);

    th::return_pool<SUI, USDC>(pool);
    version::destroy_version_for_testing(version);
    clock::destroy_for_testing(clock);
    app::destroy_acl_for_testing(admin_cap);
    test_scenario::end(scenario);
}

#[test]
public fun swap_y_to_x() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        100, // fee_rate
        597742825358017408, // sqrt price 1.05
        true,
        &version,
        &mut scenario,
    );
    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);

    let clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));
    let lower_tick = tick_math::get_tick_at_sqrt_price(583337266871351552); // lower price 1.0
    let upper_tick = tick_math::get_tick_at_sqrt_price(611809286962066560); // upper price 1.1
    let (_, _, position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 1000 sui
        1000, // 1000 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );
    transfer::public_transfer(position, tester1);
    test_scenario::next_tx(&mut scenario, tester1);
    let (balance_x, balance_y, swap_receipt) = trade::flash_swap<SUI, USDC>(
        &mut pool,
        false, // is x 2 y
        true,
        1000 * USDC_DECIMALS,
        611809286962066560, // 1.1 sqrt price limit
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    balance::destroy_for_testing<SUI>(balance_x);
    balance::destroy_for_testing<USDC>(balance_y);
    let (pay_x, pay_y) = trade::swap_receipt_debts(&swap_receipt);
    trade::repay_flash_swap<SUI, USDC>(
        &mut pool,
        swap_receipt,
        balance::create_for_testing<SUI>(pay_x),
        balance::create_for_testing<USDC>(pay_y),
        &version,
        test_scenario::ctx(&mut scenario),
    );
    th::return_pool<SUI, USDC>(pool);
    clock::destroy_for_testing(clock);
    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
public fun swap_arithmetic() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        3000, // fee_rate
        597742825358017408, // sqrt price 1.05
        true,
        &version,
        &mut scenario,
    );
    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);
    let mut clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));

    let lower_tick = tick_math::get_tick_at_sqrt_price(583337266871351552); // lower price 1.0
    let upper_tick = tick_math::get_tick_at_sqrt_price(611809286962066560); // upper price 1.1
    let (_, _, position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        100, // 1000 sui
        100, // 1000 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );
    clock::increment_for_testing(&mut clock, 10 * 1000);
    transfer::public_transfer(position, tester1);

    test_scenario::next_tx(&mut scenario, tester1);

    let (balance_x, balance_y, swap_receipt) = trade::flash_swap<SUI, USDC>(
        &mut pool,
        true, // is x 2 y
        true,
        100 * SUI_DECIMALS,
        583337266871351552, // 1.0 sqrt price limit
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    balance::destroy_for_testing<SUI>(balance_x);
    balance::destroy_for_testing<USDC>(balance_y);
    let (pay_x, pay_y) = trade::swap_receipt_debts(&swap_receipt);
    trade::repay_flash_swap<SUI, USDC>(
        &mut pool,
        swap_receipt,
        balance::create_for_testing<SUI>(pay_x),
        balance::create_for_testing<USDC>(pay_y),
        &version,
        test_scenario::ctx(&mut scenario),
    );
    clock::increment_for_testing(&mut clock, 100000 * 1000);

    let (balance_x, balance_y, swap_receipt) = trade::flash_swap<SUI, USDC>(
        &mut pool,
        false, // is x 2 y
        true,
        100 * USDC_DECIMALS,
        79226673515401279992447579055, // 1.0 sqrt price limit
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    balance::destroy_for_testing<SUI>(balance_x);
    balance::destroy_for_testing<USDC>(balance_y);
    let (pay_x, pay_y) = trade::swap_receipt_debts(&swap_receipt);
    trade::repay_flash_swap<SUI, USDC>(
        &mut pool,
        swap_receipt,
        balance::create_for_testing<SUI>(pay_x),
        balance::create_for_testing<USDC>(pay_y),
        &version,
        test_scenario::ctx(&mut scenario),
    );
    clock::increment_for_testing(&mut clock, 100000 * 1000);

    let lower_tick_1 = tick_math::get_tick_at_sqrt_price(583337266871351552); // lower price 1.0
    let upper_tick_1 = tick_math::get_tick_at_sqrt_price(611809286962066560); // upper price 1.1

    let (_, _, position1) = add_liquidity_<SUI, USDC>(
        &mut pool,
        50000, // 1000 sui
        50000, // 1000 usdc
        lower_tick_1,
        upper_tick_1,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );
    clock::increment_for_testing(&mut clock, 10 * 1000);
    transfer::public_transfer(position1, tester1);
    clock::increment_for_testing(&mut clock, 10 * 1000);

    let (balance_x, balance_y, swap_receipt) = trade::flash_swap<SUI, USDC>(
        &mut pool,
        true, // is x 2 y
        true,
        100000 * SUI_DECIMALS,
        583337266871351552, // 1.0 sqrt price limit
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    balance::destroy_for_testing<SUI>(balance_x);
    balance::destroy_for_testing<USDC>(balance_y);
    let (pay_x, pay_y) = trade::swap_receipt_debts(&swap_receipt);
    trade::repay_flash_swap<SUI, USDC>(
        &mut pool,
        swap_receipt,
        balance::create_for_testing<SUI>(pay_x),
        balance::create_for_testing<USDC>(pay_y),
        &version,
        test_scenario::ctx(&mut scenario),
    );

    th::return_pool<SUI, USDC>(pool);
    clock::destroy_for_testing(clock);
    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
public fun swap_x_to_y() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        3000, // fee_rate
        597742825358017408, // sqrt price 1.05
        true,
        &version,
        &mut scenario,
    );
    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);

    let clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));
    let lower_tick = tick_math::get_tick_at_sqrt_price(583337266871351552); // lower price 1.0
    let upper_tick = tick_math::get_tick_at_sqrt_price(611809286962066560); // upper price 1.1
    let (_, _, position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 1000 sui
        1000, // 1000 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );
    transfer::public_transfer(position, tester1);

    test_scenario::next_tx(&mut scenario, tester1);
    let (balance_x, balance_y, swap_receipt) = trade::flash_swap<SUI, USDC>(
        &mut pool,
        true, // is x 2 y
        true,
        10 * SUI_DECIMALS,
        583337266871351552, // 1.0 sqrt price limit
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    balance::destroy_for_testing<SUI>(balance_x);
    balance::destroy_for_testing<USDC>(balance_y);
    let (pay_x, pay_y) = trade::swap_receipt_debts(&swap_receipt);
    trade::repay_flash_swap<SUI, USDC>(
        &mut pool,
        swap_receipt,
        balance::create_for_testing<SUI>(pay_x),
        balance::create_for_testing<USDC>(pay_y),
        &version,
        test_scenario::ctx(&mut scenario),
    );
    th::return_pool<SUI, USDC>(pool);
    clock::destroy_for_testing(clock);
    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
public fun protocol_fee() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        100, // fee_rate
        597742825358017408, // sqrt price 1.05
        true,
        &version,
        &mut scenario,
    );
    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);
    let clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));

    let lower_tick = tick_math::get_tick_at_sqrt_price(583337266871351552); // lower price 1.0
    let upper_tick = tick_math::get_tick_at_sqrt_price(611809286962066560); // upper price 1.1
    let (_, _, position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 1000 sui
        1000, // 1000 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );
    transfer::public_transfer(position, tester1);
    test_scenario::next_tx(&mut scenario, tester1);
    let admin_cap = app::create_acl_for_testing(test_scenario::ctx(&mut scenario));
    admin::set_protocol_swap_fee_share<SUI, USDC>(
        &admin_cap,
        &mut pool,
        25_0000, // 25%
        &version,
        test_scenario::ctx(&mut scenario),
    );

    test_scenario::next_tx(&mut scenario, tester1);
    let (balance_x, balance_y, swap_receipt) = trade::flash_swap<SUI, USDC>(
        &mut pool,
        false, // is x 2 y
        true,
        1000 * USDC_DECIMALS,
        611809286962066560, // 1.1 sqrt price limit
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    balance::destroy_for_testing<SUI>(balance_x);
    balance::destroy_for_testing<USDC>(balance_y);
    let (pay_x, pay_y) = trade::swap_receipt_debts(&swap_receipt);

    trade::repay_flash_swap<SUI, USDC>(
        &mut pool,
        swap_receipt,
        balance::create_for_testing<SUI>(pay_x),
        balance::create_for_testing<USDC>(pay_y),
        &version,
        test_scenario::ctx(&mut scenario),
    );

    let (balance_x, balance_y, swap_receipt) = trade::flash_swap<SUI, USDC>(
        &mut pool,
        true, // is x 2 y
        true,
        1000 * SUI_DECIMALS,
        42999940923, // 1.1 sqrt price limit
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    balance::destroy_for_testing<SUI>(balance_x);
    balance::destroy_for_testing<USDC>(balance_y);
    let (pay_x, pay_y) = trade::swap_receipt_debts(&swap_receipt);
    trade::repay_flash_swap<SUI, USDC>(
        &mut pool,
        swap_receipt,
        balance::create_for_testing<SUI>(pay_x),
        balance::create_for_testing<USDC>(pay_y),
        &version,
        test_scenario::ctx(&mut scenario),
    );

    th::return_pool<SUI, USDC>(pool);
    clock::destroy_for_testing(clock);
    version::destroy_version_for_testing(version);
    app::destroy_acl_for_testing(admin_cap);
    test_scenario::end(scenario);
}

#[test]
public fun rewards() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        3000, // fee_rate
        597742825358017408, // sqrt price 1.05
        true,
        &version,
        &mut scenario,
    );
    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);
    let mut clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));
    let admin_cap = app::create_acl_for_testing(test_scenario::ctx(&mut scenario));

    let lower_tick = tick_math::get_tick_at_sqrt_price(583337266871351552); // lower price 1.0
    let upper_tick = tick_math::get_tick_at_sqrt_price(611809286962066560); // upper price 1.1
    let (_, _, mut position1) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 1000 sui
        1000, // 1000 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );

    // initialise pool rewards.
    admin::initialize_pool_reward<SUI, USDC, SUI>(
        &admin_cap,
        &mut pool,
        utils::to_seconds(clock::timestamp_ms(&clock) + 1000), // start time
        600, // 600 seconds post 1 sec cool down.
        balance::create_for_testing<SUI>(100 * SUI_DECIMALS),
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    test_scenario::next_tx(&mut scenario, tester1);

    let reward = collect::reward<SUI, USDC, SUI>(
        &mut pool,
        &mut position1,
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );
    coin::burn_for_testing<SUI>(reward);

    // cuurent time - 601s
    clock::increment_for_testing(&mut clock, 601 * 1000);
    test_scenario::next_tx(&mut scenario, tester1);

    let reward = collect::reward<SUI, USDC, SUI>(
        &mut pool,
        &mut position1,
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );
    coin::burn_for_testing<SUI>(reward);

    // cuurent time - 701s
    clock::increment_for_testing(&mut clock, 100 * 1000);
    let (_, _, mut position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 1000 sui
        1000, // 1000 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );
    test_scenario::next_tx(&mut scenario, tester1);

    // cuurent time - 801s
    clock::increment_for_testing(&mut clock, 100 * 1000);

    let (balance_x, balance_y, swap_receipt) = trade::flash_swap<SUI, USDC>(
        &mut pool,
        false, // is x 2 y
        true,
        100 * USDC_DECIMALS,
        79226673515401279992447579055, // 1.0 sqrt price limit
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    balance::destroy_for_testing<SUI>(balance_x);
    balance::destroy_for_testing<USDC>(balance_y);
    let (pay_x, pay_y) = trade::swap_receipt_debts(&swap_receipt);
    trade::repay_flash_swap<SUI, USDC>(
        &mut pool,
        swap_receipt,
        balance::create_for_testing<SUI>(pay_x),
        balance::create_for_testing<USDC>(pay_y),
        &version,
        test_scenario::ctx(&mut scenario),
    );

    // cuurent time - 901s
    clock::increment_for_testing(&mut clock, 100 * 1000);

    // AGAIN REFILL rewards with 300s as non-dispersion phase.

    // add 300 (to make up for lost 300s) + 100s as new emiision duration.
    admin::update_pool_reward_emission<SUI, USDC, SUI>(
        &admin_cap,
        &mut pool,
        balance::create_for_testing<SUI>(100 * SUI_DECIMALS),
        401,
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    // cuurent time - 1001s
    clock::increment_for_testing(&mut clock, 100 * 1000);

    let reward = collect::reward<SUI, USDC, SUI>(
        &mut pool,
        &mut position,
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );
    let rewardf = collect::reward<SUI, USDC, SUI>(
        &mut pool,
        &mut position1,
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );
    coin::burn_for_testing<SUI>(reward);
    coin::burn_for_testing<SUI>(rewardf);
    transfer::public_transfer(position1, tester1);
    app::destroy_acl_for_testing(admin_cap);
    th::return_pool<SUI, USDC>(pool);
    clock::destroy_for_testing(clock);
    transfer::public_transfer(position, tester1);
    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
public fun rewards_remove_lp() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));

    create_pool_<SUI, USDC>(
        3000, // fee_rate
        597742825358017408, // sqrt price 1.05
        true,
        &version,
        &mut scenario,
    );
    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);
    let mut clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));

    let lower_tick = tick_math::get_tick_at_sqrt_price(583337266871351552); // lower price 1.0
    let upper_tick = tick_math::get_tick_at_sqrt_price(611809286962066560); // upper price 1.1
    let (_, _, position1) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 1000 sui
        1000, // 1000 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );
    transfer::public_transfer(position1, tester1);

    test_scenario::next_tx(&mut scenario, tester1);
    let admin_cap = app::create_acl_for_testing(test_scenario::ctx(&mut scenario));

    // initialise pool rewards.
    admin::initialize_pool_reward<SUI, USDC, SUI>(
        &admin_cap,
        &mut pool,
        utils::to_seconds(clock::timestamp_ms(&clock) + 1000), // start time
        1 * SUI_DECIMALS, // 1 sui / sec
        balance::create_for_testing<SUI>(100 * SUI_DECIMALS),
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    // elapse time
    clock::increment_for_testing(&mut clock, 2000);
    test_scenario::next_tx(&mut scenario, tester1);
    let (_, _, mut position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 1000 sui
        1000, // 1000 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );
    test_scenario::next_tx(&mut scenario, tester1);
    let reward = collect::reward<SUI, USDC, SUI>(
        &mut pool,
        &mut position,
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    let (fee_x, fee_y) = collect::fee<SUI, USDC>(
        &mut pool,
        &mut position,
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );
    let position_liquidity = position::liquidity(&position);
    let (rem_x, rem_y) = liquidity::remove_liquidity(
        &mut pool,
        &mut position,
        position_liquidity,
        0,
        0,
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    coin::burn_for_testing<SUI>(rem_x);
    coin::burn_for_testing<USDC>(rem_y);
    coin::burn_for_testing<SUI>(reward);
    coin::burn_for_testing<SUI>(fee_x);
    coin::burn_for_testing<USDC>(fee_y);

    liquidity::close_position(
        position,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    app::destroy_acl_for_testing(admin_cap);
    th::return_pool<SUI, USDC>(pool);
    clock::destroy_for_testing(clock);
    // transfer::public_transfer(position, tester1);
    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
public fun multi_rewards() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));
    create_pool_<SUI, USDC>(
        3000, // fee_rate
        597742825358017408, // sqrt price 1.05
        true,
        &version,
        &mut scenario,
    );
    test_scenario::next_tx(&mut scenario, tester1);
    let mut pool = th::take_pool<SUI, USDC>(&mut scenario);

    let lower_tick = tick_math::get_tick_at_sqrt_price(583337266871351552); // lower price 1.0
    let upper_tick = tick_math::get_tick_at_sqrt_price(611809286962066560); // upper price 1.1
    let mut clock = clock::create_for_testing(test_scenario::ctx(&mut scenario));
    let (_, _, position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 1000 sui
        1000, // 1000 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );
    transfer::public_transfer(position, tester1);
    test_scenario::next_tx(&mut scenario, tester1);
    let admin_cap = app::create_acl_for_testing(test_scenario::ctx(&mut scenario));

    // initialise pool rewards.
    admin::initialize_pool_reward<SUI, USDC, SUI>(
        &admin_cap,
        &mut pool,
        utils::to_seconds(clock::timestamp_ms(&clock) + 1000), // start time
        1 * SUI_DECIMALS, // 1 sui / sec
        balance::create_for_testing<SUI>(100 * SUI_DECIMALS),
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    // initialise pool rewards.
    admin::initialize_pool_reward<SUI, USDC, USDC>(
        &admin_cap,
        &mut pool,
        utils::to_seconds(clock::timestamp_ms(&clock) + 1000), // start time
        100000, // additional seconds
        balance::create_for_testing<USDC>(100 * USDC_DECIMALS),
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    // elapse time
    clock::increment_for_testing(&mut clock, 2000);
    test_scenario::next_tx(&mut scenario, tester1);
    let (_, _, position) = add_liquidity_<SUI, USDC>(
        &mut pool,
        1000, // 1000 sui
        1000, // 1000 usdc
        lower_tick,
        upper_tick,
        tester1,
        &clock,
        &version,
        &mut scenario,
    );
    transfer::public_transfer(position, tester1);

    test_scenario::next_tx(&mut scenario, tester1);
    let mut position = th::take_position(&mut scenario, tester1);
    let reward = collect::reward<SUI, USDC, SUI>(
        &mut pool,
        &mut position,
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

  coin::burn_for_testing<SUI>(reward);

    let reward_1 = collect::reward<SUI, USDC, USDC>(
        &mut pool,
        &mut position,
        &clock,
        &version,
        test_scenario::ctx(&mut scenario),
    );

    coin::burn_for_testing<USDC>(reward_1);

    app::destroy_acl_for_testing(admin_cap);
    th::return_pool<SUI, USDC>(pool);
    clock::destroy_for_testing(clock);
    th::return_position(position, tester1);
    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}
