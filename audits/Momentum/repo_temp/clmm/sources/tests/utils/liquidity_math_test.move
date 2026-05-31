#[test_only]
module mmt_v3::liquidity_math_test;

use mmt_v3::i128::{Self, I128};
use mmt_v3::liquidity_math;

#[test]
public fun test_add_delta() {
    let current_liquidity: u128 = 10000000000;
    let delta_liquidity: I128 = i128::from(10000000000);
    let result = liquidity_math::add_delta(current_liquidity, delta_liquidity);
    assert!(result == 20000000000);
}

#[test]
public fun test_add_delta_negative() {
    let current_liquidity: u128 = 10000000000;
    let delta_liquidity: I128 = i128::neg_from(10000000000);
    let result = liquidity_math::add_delta(current_liquidity, delta_liquidity);
    assert!(result == 0);
}

#[test]
public fun test_get_amount_x_for_liquidity() {
    let sqrt_price_current = 18446744073709551616; // 1.0
    let sqrt_price_target = 20291418481080506777; // 1.1
    let liquidity = 11000000000;
    let result = liquidity_math::get_amount_x_for_liquidity(
        sqrt_price_current,
        sqrt_price_target,
        liquidity,
        true,
    );
    assert!(result == 1000000000);
}

#[test]
public fun test_get_amount_y_for_liquidity() {
    let sqrt_price_current = 18446744073709551616; // 1.0
    let sqrt_price_target = 16602069666338695854; // 0.9
    let liquidity = 11000000000;
    let result = liquidity_math::get_amount_y_for_liquidity(
        sqrt_price_current,
        sqrt_price_target,
        liquidity,
        true,
    );
    assert!(result == 1100000000);
}

#[test]
public fun test_get_amounts_for_liquidity() {
    let sqrt_price_current = 18446744073709551616; // 1.0
    let sqrt_price_lower = 16602069666338695854; // 0.9
    let sqrt_price_upper = 20291418481080506777; // 1.1
    let liquidity = 11000000000;
    let (amount_x, amount_y) = liquidity_math::get_amounts_for_liquidity(
        sqrt_price_current,
        sqrt_price_lower,
        sqrt_price_upper,
        liquidity,
        true,
    );
    assert!(amount_x == 1000000000);
    assert!(amount_y == 1100000000);
}

#[test]
public fun test_get_liquidity_for_amounts_mixed() {
    // lower < current < upper
    let sqrt_price_current = 18446744073709551616; // 1.0
    let sqrt_price_lower = 16602069666338695854; // 0.9
    let sqrt_price_upper = 20291418481080506777; // 1.1
    let amount_x = 1000000000;
    let amount_y = 2000000000;
    let result = liquidity_math::get_liquidity_for_amounts(
        sqrt_price_current,
        sqrt_price_lower,
        sqrt_price_upper,
        amount_x,
        amount_y,
    );
    assert!(result == 11000000000);
}

#[test]
#[expected_failure(abort_code = 80, location = mmt_v3::liquidity_math)]
public fun test_invalid_sqrt_prices() {
    let sqrt_price_current = 10;
    let sqrt_price_lower = 40;
    let sqrt_price_upper = 20;
    let amount_x = 100;
    let amount_y = 200;
    let _ = liquidity_math::get_liquidity_for_amounts(
        sqrt_price_current,
        sqrt_price_lower,
        sqrt_price_upper,
        amount_x,
        amount_y,
    );
}

#[test]
public fun test_get_liquidity_for_amount_x() {
    let sqrt_price_current = 18446744073709551616; // 1.0
    let sqrt_price_target = 20291418481080506777; // 1.1
    let amount_x = 1000000000;
    let result = liquidity_math::get_liquidity_for_amount_x(
        sqrt_price_current,
        sqrt_price_target,
        amount_x,
    );
    assert!(result == 11000000000);
}

#[test]
public fun test_get_liquidity_for_amount_y() {
    let sqrt_price_current = 18446744073709551616; // 1.0
    let sqrt_price_target = 16602069666338695854; // 0.9
    let amount_y = 1100000000;
    let result = liquidity_math::get_liquidity_for_amount_y(
        sqrt_price_current,
        sqrt_price_target,
        amount_y,
    );
    assert!(result == 11000000000);
}

#[test]
public fun test_check_is_fix_coin_a() {
    let lower_sqrt_price = 16602069666338695854; // 0.9
    let upper_sqrt_price = 20291418481080506777; // 1.1
    let current_sqrt_price = 18446744073709551616; // 1.0
    let amount_a = 1000000000;
    let amount_b = 2000000000;
    let (is_fix_coin_a, amount_a_new, amount_b_new) = liquidity_math::check_is_fix_coin_a(
        lower_sqrt_price,
        upper_sqrt_price,
        current_sqrt_price,
        amount_a,
        amount_b,
    );
    assert!(is_fix_coin_a == true);
    assert!(amount_a_new == 1000000000);
    assert!(amount_b_new == 1100000000);
    assert!(amount_b_new != 2000000000);
}
