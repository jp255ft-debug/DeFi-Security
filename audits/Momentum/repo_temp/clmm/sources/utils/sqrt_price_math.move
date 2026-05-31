module mmt_v3::sqrt_price_math;

use mmt_v3::error;
use mmt_v3::tick_math;

public fun get_amount_x_delta(
    sqrt_price_start: u128,
    sqrt_price_end: u128,
    liquidity: u128,
    round_up: bool,
): u64 {
    assert!(sqrt_price_start > 0 && sqrt_price_end > 0, error::invalid_price_bounds());

    let price_delta = if (sqrt_price_start > sqrt_price_end) {
        sqrt_price_start - sqrt_price_end
    } else {
        sqrt_price_end - sqrt_price_start
    };
    if (price_delta == 0 || liquidity == 0) {
        return 0
    };
    let (product, overflow) = mmt_v3::math_u256::checked_shlw(
        mmt_v3::full_math_u128::full_mul(liquidity, price_delta),
    );

    assert!(!overflow, error::overflow());

    // amount_x = liquidity * (next_tick_price - current_price) / (next_tick_price * current_price)
    mmt_v3::math_u256::div_round(
        product,
        mmt_v3::full_math_u128::full_mul(sqrt_price_start, sqrt_price_end),
        round_up,
    ) as u64
}

public fun get_amount_y_delta(
    sqrt_price_start: u128,
    sqrt_price_end: u128,
    liquidity: u128,
    round_up: bool,
): u64 {
    let price_delta = if (sqrt_price_start > sqrt_price_end) {
        sqrt_price_start - sqrt_price_end
    } else {
        sqrt_price_end - sqrt_price_start
    };
    if (price_delta == 0 || liquidity == 0) {
        return 0
    };

    mmt_v3::math_u256::div_round(
        mmt_v3::full_math_u128::full_mul(liquidity, price_delta),
        mmt_v3::constants::q64() as u256,
        round_up,
    ) as u64
}

/// \[Deprecated\] Please use the new method get_next_sqrt_price_from_amount_x_input
public fun get_next_sqrt_price_from_amount_x_rouding_up(
    current_price: u128,
    liquidity: u128,
    amount: u64,
    round_up: bool,
): u128 {
    if (amount == 0) {
        return current_price
    };
    let (product, overflow) = mmt_v3::math_u256::checked_shlw(
        mmt_v3::full_math_u128::full_mul(current_price, liquidity),
    );
    assert!(!overflow, error::overflow());

    let scaled_liquidity = (liquidity as u256) << 64;
    let scaled_amount = mmt_v3::full_math_u128::full_mul(current_price, amount as u128);
    let next_price = if (round_up) {
        mmt_v3::math_u256::div_round(product, scaled_liquidity + scaled_amount, true) as u128
    } else {
        assert!(scaled_liquidity > scaled_amount, error::invalid_liquidity_scalled());

        mmt_v3::math_u256::div_round(product, scaled_liquidity - scaled_amount, true) as u128
    };
    assert!(
        next_price <= tick_math::max_sqrt_price() && next_price >= tick_math::min_sqrt_price(),
        error::invalid_next_price(),
    );
    next_price
}

/// \[Deprecated\] Please use the new method get_next_sqrt_price_from_amount_y_input
public fun get_next_sqrt_price_from_amount_y_rouding_down(
    current_price: u128,
    liquidity: u128,
    amount: u64,
    round_up: bool,
): u128 {
    let scaled_amount =
        mmt_v3::math_u256::div_round((amount as u256) << 64, liquidity as u256, !round_up) as u128;
    let next_price = if (round_up) {
        current_price + scaled_amount
    } else {
        assert!(current_price > scaled_amount, error::invalid_current_price());

        current_price - scaled_amount
    };
    assert!(
        next_price <= tick_math::max_sqrt_price() && next_price >= tick_math::min_sqrt_price(),
        error::invalid_next_price(),
    );

    next_price
}

public fun get_next_sqrt_price_from_amount_x_input(
    current_price: u128,
    liquidity: u128,
    amount: u64,
    round_up: bool,
): u128 {
    if (amount == 0) {
        return current_price
    };
    let (product, overflow) = mmt_v3::math_u256::checked_shlw(
        mmt_v3::full_math_u128::full_mul(current_price, liquidity),
    );
    assert!(!overflow, error::overflow());

    let scaled_liquidity = (liquidity as u256) << 64;
    let scaled_amount = mmt_v3::full_math_u128::full_mul(current_price, amount as u128);
    let next_price = if (round_up) {
        mmt_v3::math_u256::div_round(product, scaled_liquidity + scaled_amount, true) as u128
    } else {
        assert!(scaled_liquidity > scaled_amount, error::invalid_liquidity_scalled());

        mmt_v3::math_u256::div_round(product, scaled_liquidity - scaled_amount, true) as u128
    };
    assert!(
        next_price <= tick_math::max_sqrt_price() && next_price >= tick_math::min_sqrt_price(),
        error::invalid_next_price(),
    );
    next_price
}

public fun get_next_sqrt_price_from_amount_y_input(
    current_price: u128,
    liquidity: u128,
    amount: u64,
    round_up: bool,
): u128 {
    let scaled_amount =
        mmt_v3::math_u256::div_round((amount as u256) << 64, liquidity as u256, !round_up) as u128;
    let next_price = if (round_up) {
        current_price + scaled_amount
    } else {
        assert!(current_price > scaled_amount, error::invalid_current_price());

        current_price - scaled_amount
    };
    assert!(
        next_price <= tick_math::max_sqrt_price() && next_price >= tick_math::min_sqrt_price(),
        error::invalid_next_price(),
    );

    next_price
}

public fun get_next_sqrt_price_from_input(
    current_price: u128,
    liquidity: u128,
    amount: u64,
    is_token0: bool,
): u128 {
    assert!(current_price > 0 && liquidity > 0, error::invalid_price_or_liquidity());
    if (is_token0) {
        get_next_sqrt_price_from_amount_x_input(current_price, liquidity, amount, true)
    } else {
        get_next_sqrt_price_from_amount_y_input(current_price, liquidity, amount, true)
    }
}

public fun get_next_sqrt_price_from_output(
    current_price: u128,
    liquidity: u128,
    amount: u64,
    is_token0: bool,
): u128 {
    assert!(current_price > 0 && liquidity > 0, error::invalid_price_or_liquidity());
    if (is_token0) {
        get_next_sqrt_price_from_amount_y_input(current_price, liquidity, amount, false)
    } else {
        get_next_sqrt_price_from_amount_x_input(current_price, liquidity, amount, false)
    }
}
