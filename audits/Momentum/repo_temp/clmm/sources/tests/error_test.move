#[test_only]
module mmt_v3::error_test;

use mmt_v3::error;

#[test]
fun test_zero() {
    assert!(error::zero() == 0);
}

#[test]
fun test_invalid_fee_rate() {
    assert!(error::invalid_fee_rate() == 1);
}

#[test]
fun test_fee_rate_already_configured() {
    assert!(error::fee_rate_already_configured() == 2);
}

#[test]
fun test_invalid_timestamp() {
    assert!(error::invalid_timestamp() == 3);
}

#[test]
fun test_invalid_protocol_fee() {
    assert!(error::invalid_protocol_fee() == 4);
}

#[test]
fun test_invalid_amounts() {
    assert!(error::invalid_amounts() == 5);
}

#[test]
fun test_invalid_tick_spacing() {
    assert!(error::invalid_tick_spacing() == 6);
}

#[test]
fun test_high_slippage() {
    assert!(error::high_slippage() == 7);
}

#[test]
fun test_invalid_price_limit() {
    assert!(error::invalid_price_limit() == 8);
}

#[test]
fun test_invalid_reserves_state() {
    assert!(error::invalid_reserves_state() == 9);
}

#[test]
fun test_insufficient_liquidity() {
    assert!(error::insufficient_liquidity() == 10);
}

#[test]
fun test_insufficient_funds() {
    assert!(error::insufficient_funds() == 11);
}

#[test]
fun test_invalid_pool_match() {
    assert!(error::invalid_pool_match() == 12);
}

#[test]
fun test_invalid_initialization() {
    assert!(error::invalid_initialization() == 13);
}

#[test]
fun test_index_out_of_bounds() {
    assert!(error::index_out_of_bounds() == 14);
}

#[test]
fun test_invalid_last_update_time() {
    assert!(error::invalid_last_update_time() == 15);
}

#[test]
fun test_invalid_fee_growth() {
    assert!(error::invalid_fee_growth() == 16);
}

#[test]
fun test_add_check_failed() {
    assert!(error::add_check_failed() == 17);
}

#[test]
fun test_update_rewards_info_check_failed() {
    assert!(error::update_rewards_info_check_failed() == 18);
}

#[test]
fun test_invalid_tick() {
    assert!(error::invalid_tick() == 19);
}

#[test]
fun test_overflow() {
    assert!(error::overflow() == 20);
}

#[test]
fun test_invalid_observation_timestamp() {
    assert!(error::invalid_observation_timestamp() == 21);
}

#[test]
fun test_grow_obs_check_failed() {
    assert!(error::grow_obs_check_failed() == 22);
}

#[test]
fun test_observe_checks() {
    assert!(error::observe_checks() == 23);
}

#[test]
fun test_invalid_price_bounds() {
    assert!(error::invalid_price_bounds() == 24);
}

#[test]
fun test_invalid_liquidity_scalled() {
    assert!(error::invalid_liquidity_scalled() == 25);
}

#[test]
fun test_invalid_next_price() {
    assert!(error::invalid_next_price() == 26);
}

#[test]
fun test_invalid_current_price() {
    assert!(error::invalid_current_price() == 27);
}

#[test]
fun test_reward_index_not_found() {
    assert!(error::reward_index_not_found() == 28);
}

#[test]
fun test_invalid_create_pool_configs() {
    assert!(error::invalid_create_pool_configs() == 29);
}

#[test]
fun test_position_not_empty() {
    assert!(error::position_not_empty() == 30);
}

#[test]
fun test_pool_not_initialised() {
    assert!(error::pool_not_initialised() == 31);
}

#[test]
fun test_not_authorised() {
    assert!(error::not_authorised() == 32);
}

#[test]
fun test_version_not_supported() {
    assert!(error::version_not_supported() == 69);
}

#[test]
fun test_pool_is_pause() {
    assert!(error::pool_is_pause() == 70);
}

#[test]
fun test_invalid_pool_coin_types() {
    assert!(error::invalid_pool_coin_types() == 71);
}

#[test]
fun test_invalid_tick_range() {
    assert!(error::invalid_tick_range() == 72);
}

#[test]
fun test_invalid_min_tick_range_factor() {
    assert!(error::invalid_min_tick_range_factor() == 73);
}

#[test]
fun test_exceed_max_liquidity_per_tick() {
    assert!(error::exceed_max_liquidity_per_tick() == 74);
}

#[test]
fun test_trading_disabled() {
    assert!(error::trading_disabled() == 75);
}

#[test]
fun test_invalid_price_or_liquidity() {
    assert!(error::invalid_price_or_liquidity() == 76);
}

#[test]
fun test_value_out_of_range() {
    assert!(error::value_out_of_range() == 77);
}

#[test]
fun test_invalid_minor_version() {
    assert!(error::invalid_minor_version() == 78);
}

#[test]
fun test_invalid_major_version() {
    assert!(error::invalid_major_version() == 79);
}

#[test]
fun test_invalid_sqrt_prices() {
    assert!(error::invalid_sqrt_prices() == 80);
}

#[test]
fun test_invalid_pool_coin_types_sorted() {
    assert!(error::invalid_pool_coin_types_sorted() == 81);
}
