#[test_only]
module mmt_v3::sqrt_price_math_test;

use mmt_v3::sqrt_price_math;
use mmt_v3::tick_math;

#[test]
fun test_get_amount_x_delta_basic() {
    let sqrt_price_start: u128 = 18446744073709551616; // 1.0
    let sqrt_price_end: u128 = 20291418481080506778; // 1.1
    let liquidity: u128 = 1000000000000000000; // 1e18
    let round_up = true;

    let amount_x = sqrt_price_math::get_amount_x_delta(
        sqrt_price_start,
        sqrt_price_end,
        liquidity,
        round_up,
    );
    assert!(amount_x == 90909090909090910);
}

#[test]
fun test_get_amount_y_delta_basic() {
    let sqrt_price_start: u128 = 18446744073709551616; // 1.0
    let sqrt_price_end: u128 = 20291418481080506778; // 1.1
    let liquidity: u128 = 1000000000000000000; // 1e18
    let round_up = true;

    let amount_y = sqrt_price_math::get_amount_y_delta(
        sqrt_price_start,
        sqrt_price_end,
        liquidity,
        round_up,
    );
    assert!(amount_y == 100000000000000001);
}

#[test]
#[expected_failure(abort_code = 20, location = mmt_v3::sqrt_price_math)]
fun test_get_amount_x_delta_overflow() {
    let sqrt_price_start: u128 = 0xffffffffffffffffffffffffffffffff;
    let sqrt_price_end: u128 = 1;
    let liquidity: u128 = 0xffffffffffffffffffffffffffffffff; // Max u128
    let round_up = true;

    let _amount_x = sqrt_price_math::get_amount_x_delta(
        sqrt_price_start,
        sqrt_price_end,
        liquidity,
        round_up,
    );
}

#[test]
fun test_get_next_sqrt_price_from_amount_x_input_basic() {
    let current_price: u128 = 18446744073709551616; // 1.0
    let liquidity: u128 = 1000000000000000000; // 1e18
    let amount: u64 = 1000000000; // 1e9
    let round_up = true;

    let next_price = sqrt_price_math::get_next_sqrt_price_from_amount_x_input(
        current_price,
        liquidity,
        amount,
        round_up,
    );
    assert!(next_price == 18446744055262807561);
    assert!(next_price <= tick_math::max_sqrt_price());
    assert!(next_price >= tick_math::min_sqrt_price());
}

#[test]
fun test_get_next_sqrt_price_from_amount_y_input_basic() {
    let current_price: u128 = 18446744073709551616; // 1.0
    let liquidity: u128 = 1000000000000000000; // 1e18
    let amount: u64 = 1000000000; // 1e9
    let round_up = true;

    let next_price = sqrt_price_math::get_next_sqrt_price_from_amount_y_input(
        current_price,
        liquidity,
        amount,
        round_up,
    );
    assert!(next_price == 18446744092156295689);
    assert!(next_price <= tick_math::max_sqrt_price());
    assert!(next_price >= tick_math::min_sqrt_price());
}

#[test]
fun test_get_next_sqrt_price_from_amount_y_input_round_down() {
    let current_price: u128 = 18446744073709551616; // 1.0
    let liquidity: u128 = 1000000000000000000; // 1e18
    let amount: u64 = 1000000000; // 1e9
    let round_up = false;

    let next_price = sqrt_price_math::get_next_sqrt_price_from_amount_y_input(
        current_price,
        liquidity,
        amount,
        round_up,
    );
    assert!(next_price == 18446744055262807542);
    assert!(next_price < current_price);
    assert!(next_price <= tick_math::max_sqrt_price());
    assert!(next_price >= tick_math::min_sqrt_price());
}

#[test]
fun test_get_next_sqrt_price_from_input_token0() {
    let current_price: u128 = 18446744073709551616; // 1.0
    let liquidity: u128 = 1000000000000000000; // 1e18
    let amount: u64 = 1000000000; // 1e9
    let is_token0 = true;

    let next_price = sqrt_price_math::get_next_sqrt_price_from_input(
        current_price,
        liquidity,
        amount,
        is_token0,
    );
    assert!(next_price == 18446744055262807561);
    assert!(next_price <= tick_math::max_sqrt_price());
    assert!(next_price >= tick_math::min_sqrt_price());
}

#[test]
fun test_get_next_sqrt_price_from_input_token1() {
    let current_price: u128 = 18446744073709551616; // 1.0
    let liquidity: u128 = 1000000000000000000; // 1e18
    let amount: u64 = 1000000000; // 1e9
    let is_token0 = false;

    let next_price = sqrt_price_math::get_next_sqrt_price_from_input(
        current_price,
        liquidity,
        amount,
        is_token0,
    );
    assert!(next_price == 18446744092156295689);
    assert!(next_price > current_price);
    assert!(next_price <= tick_math::max_sqrt_price());
    assert!(next_price >= tick_math::min_sqrt_price());
}

#[test]
fun test_get_next_sqrt_price_from_output_token0() {
    let current_price: u128 = 18446744073709551616; // 1.0
    let liquidity: u128 = 1000000000000000000; // 1e18
    let amount: u64 = 1000000000; // 1e9
    let is_token0 = true;

    let next_price = sqrt_price_math::get_next_sqrt_price_from_output(
        current_price,
        liquidity,
        amount,
        is_token0,
    );
    assert!(next_price == 18446744055262807542);
    assert!(next_price < current_price);
    assert!(next_price <= tick_math::max_sqrt_price());
    assert!(next_price >= tick_math::min_sqrt_price());
}

#[test]
fun test_get_next_sqrt_price_from_output_token1() {
    let current_price: u128 = 18446744073709551616; // 1.0
    let liquidity: u128 = 1000000000000000000; // 1e18
    let amount: u64 = 1000000000; // 1e9
    let is_token0 = false;

    let next_price = sqrt_price_math::get_next_sqrt_price_from_output(
        current_price,
        liquidity,
        amount,
        is_token0,
    );
    assert!(next_price > 0);
    assert!(next_price <= tick_math::max_sqrt_price());
    assert!(next_price >= tick_math::min_sqrt_price());
}

#[test]
fun test_deprecated_functions_basic() {
    let current_price: u128 = 18446744073709551616; // 1.0
    let liquidity: u128 = 1000000000000000000; // 1e18
    let amount: u64 = 1000000000; // 1e9
    let round_up = true;

    let next_price_x = sqrt_price_math::get_next_sqrt_price_from_amount_x_rouding_up(
        current_price,
        liquidity,
        amount,
        round_up,
    );
    assert!(next_price_x > 0);
    assert!(next_price_x <= tick_math::max_sqrt_price());
    assert!(next_price_x >= tick_math::min_sqrt_price());

    let next_price_y = sqrt_price_math::get_next_sqrt_price_from_amount_y_rouding_down(
        current_price,
        liquidity,
        amount,
        round_up,
    );
    assert!(next_price_y > current_price);
    assert!(next_price_y <= tick_math::max_sqrt_price());
    assert!(next_price_y >= tick_math::min_sqrt_price());
}

#[test]
fun test_extreme_price_scenarios() {
    // Test with very high and very low prices
    let high_price: u128 = 100000000000000000000000000000000000000;
    let low_price: u128 = 1000000000000000000;
    let liquidity: u128 = 1000000000000000000;
    let amount: u64 = 1000000000;

    // Test high price scenario
    let next_price_high = sqrt_price_math::get_next_sqrt_price_from_amount_x_input(
        high_price,
        liquidity,
        amount,
        true,
    );
    assert!(next_price_high > 0);
    assert!(next_price_high <= tick_math::max_sqrt_price());
    assert!(next_price_high >= tick_math::min_sqrt_price());

    // Test low price scenario
    let next_price_low = sqrt_price_math::get_next_sqrt_price_from_amount_y_input(
        low_price,
        liquidity,
        amount,
        true,
    );
    assert!(next_price_low > low_price);
    assert!(next_price_low <= tick_math::max_sqrt_price());
    assert!(next_price_low >= tick_math::min_sqrt_price());
}

#[test]
fun test_large_liquidity_scenarios() {
    let current_price: u128 = 18446744073709551616; // 1.0
    let large_liquidity: u128 = 10000000000000000000;
    let small_amount: u64 = 1000;
    let large_amount: u64 = 100000000000;

    let next_price_small = sqrt_price_math::get_next_sqrt_price_from_amount_x_input(
        current_price,
        large_liquidity,
        small_amount,
        true,
    );
    assert!(next_price_small > 0);
    assert!(next_price_small <= tick_math::max_sqrt_price());
    assert!(next_price_small >= tick_math::min_sqrt_price());

    let next_price_large = sqrt_price_math::get_next_sqrt_price_from_amount_y_input(
        current_price,
        large_liquidity,
        large_amount,
        true,
    );
    assert!(next_price_large <= tick_math::max_sqrt_price());
    assert!(next_price_large >= tick_math::min_sqrt_price());

    let amount_x_delta = sqrt_price_math::get_amount_x_delta(
        current_price,
        next_price_small,
        large_liquidity,
        true,
    );
    assert!(amount_x_delta > 0);

    let amount_y_delta = sqrt_price_math::get_amount_y_delta(
        current_price,
        next_price_large,
        large_liquidity,
        true,
    );
    assert!(amount_y_delta > 0);
}

#[test]
#[expected_failure(abort_code = 26, location = mmt_v3::sqrt_price_math)]
fun test_get_next_sqrt_price_from_amount_x_input_invalid_price_too_high() {
    let current_price: u128 = tick_math::max_sqrt_price();
    let liquidity: u128 = 1000000000000000000;
    let amount: u64 = 1;
    let round_up = false;

    let _next_price = sqrt_price_math::get_next_sqrt_price_from_amount_x_input(
        current_price,
        liquidity,
        amount,
        round_up,
    );
}
