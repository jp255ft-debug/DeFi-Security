module mmt_v3::liquidity_math;

use mmt_v3::error;
use mmt_v3::i128::I128;
use mmt_v3::sqrt_price_math;

public fun add_delta(current_liquidity: u128, delta_liquidity: I128): u128 {
    let abs_delta = mmt_v3::i128::abs_u128(delta_liquidity);
    if (mmt_v3::i128::is_neg(delta_liquidity)) {
        assert!(current_liquidity >= abs_delta, error::insufficient_liquidity());
        current_liquidity - abs_delta
    } else {
        assert!(
            abs_delta < mmt_v3::constants::max_u128() - current_liquidity,
            error::insufficient_liquidity(),
        );
        current_liquidity + abs_delta
    }
}

// get amount x for delta liquidity
public fun get_amount_x_for_liquidity(
    sqrt_price_current: u128,
    sqrt_price_target: u128,
    liquidity: u128,
    round_up: bool,
): u64 {
    // price_diff = mod(p_x - p_y)
    // amount_x = (L * price_diff) / (p_l * p_u)
    let (sqrt_price_lower, sqrt_price_upper) = sort_sqrt_prices(
        sqrt_price_current,
        sqrt_price_target,
    );

    let (product, overflow) = mmt_v3::math_u256::checked_shlw(
        mmt_v3::full_math_u128::full_mul(liquidity, sqrt_price_upper - sqrt_price_lower),
    );
    assert!(!overflow, error::overflow());

    mmt_v3::math_u256::div_round(
        product,
        mmt_v3::full_math_u128::full_mul(sqrt_price_lower, sqrt_price_upper),
        round_up,
    ) as u64
}

// get amount y for delta liquidity.
public fun get_amount_y_for_liquidity(
    sqrt_price_current: u128,
    sqrt_price_target: u128,
    liquidity: u128,
    round_up: bool,
): u64 {
    // price_diff = mod(p_x - p_y)
    // amount_y = L * price_diff
    let (sqrt_price_lower, sqrt_price_upper) = sort_sqrt_prices(
        sqrt_price_current,
        sqrt_price_target,
    );
    mmt_v3::math_u256::div_round(
        mmt_v3::full_math_u128::full_mul(liquidity, sqrt_price_upper - sqrt_price_lower),
        mmt_v3::constants::q64() as u256,
        round_up,
    ) as u64
}

// returns amounts of both assets as per delta liquidity.
public fun get_amounts_for_liquidity(
    sqrt_price_current: u128,
    sqrt_price_lower: u128,
    sqrt_price_upper: u128,
    liquidity: u128,
    round_up: bool,
): (u64, u64) {
    assert!(sqrt_price_lower < sqrt_price_upper, error::invalid_sqrt_prices());
    if (sqrt_price_current <= sqrt_price_lower) {
        (
            // amount x
            sqrt_price_math::get_amount_x_delta(
                sqrt_price_lower,
                sqrt_price_upper,
                liquidity,
                round_up,
            ),
            // amount y
            0,
        )
    } else {
        let (amount_x, amount_y) = if (sqrt_price_current < sqrt_price_upper) {
            (
                sqrt_price_math::get_amount_x_delta(
                    sqrt_price_current,
                    sqrt_price_upper,
                    liquidity,
                    round_up,
                ),
                sqrt_price_math::get_amount_y_delta(
                    sqrt_price_lower,
                    sqrt_price_current,
                    liquidity,
                    round_up,
                ),
            )
        } else {
            (
                0,
                sqrt_price_math::get_amount_y_delta(
                    sqrt_price_lower,
                    sqrt_price_upper,
                    liquidity,
                    round_up,
                ),
            )
        };
        (amount_x, amount_y)
    }
}

// get delta liquidity by amount x.
public fun get_liquidity_for_amount_x(
    sqrt_price_current: u128,
    sqrt_price_target: u128,
    amount_x: u64,
): u128 {
    // price_diff = mod(p_x - p_y)
    // L = dX * (p_x * p_y) / (p_x - p_y)
    let (sqrt_price_lower, sqrt_price_upper) = sort_sqrt_prices(
        sqrt_price_current,
        sqrt_price_target,
    );
    mmt_v3::full_math_u128::mul_div_floor(
        amount_x as u128,
        mmt_v3::full_math_u128::mul_div_floor(
            sqrt_price_lower,
            sqrt_price_upper,
            mmt_v3::constants::q64() as u128,
        ),
        sqrt_price_upper - sqrt_price_lower,
    )
}

// get delta liquidity by amount y.
public fun get_liquidity_for_amount_y(
    sqrt_price_current: u128,
    sqrt_price_target: u128,
    amount_y: u64,
): u128 {
    // price_diff = mod(p_x - p_y)
    // L = dY / price_diff
    let (sqrt_price_lower, sqrt_price_upper) = sort_sqrt_prices(
        sqrt_price_current,
        sqrt_price_target,
    );
    mmt_v3::full_math_u128::mul_div_floor(
        amount_y as u128,
        mmt_v3::constants::q64() as u128,
        sqrt_price_upper - sqrt_price_lower,
    )
}

// returns liquidity from amounts x & y.
public fun get_liquidity_for_amounts(
    sqrt_price_current: u128,
    sqrt_price_lower: u128,
    sqrt_price_upper: u128,
    amount_x: u64,
    amount_y: u64,
): u128 {
    assert!(sqrt_price_lower < sqrt_price_upper, error::invalid_sqrt_prices());

    // current_tick < tick_lower
    if (sqrt_price_current <= sqrt_price_lower) {
        // return liquidity calculated from amount x.
        get_liquidity_for_amount_x(sqrt_price_lower, sqrt_price_upper, amount_x)
    } else {
        // current_tick >= tick_lower
        let liquidity = if (sqrt_price_current < sqrt_price_upper) {
            mmt_v3::math_u128::min(
                get_liquidity_for_amount_x(sqrt_price_current, sqrt_price_upper, amount_x),
                get_liquidity_for_amount_y(sqrt_price_lower, sqrt_price_current, amount_y),
            )
        } else {
            // return liquidity calculated from amount x.
            get_liquidity_for_amount_y(sqrt_price_lower, sqrt_price_upper, amount_y)
        };
        liquidity
    }
}

public fun check_is_fix_coin_a(
    lower_sqrt_price: u128,
    upper_sqrt_price: u128,
    current_sqrt_price: u128,
    amount_a: u64,
    amount_b: u64,
): (bool, u64, u64) {
    let (dl) = get_liquidity_for_amounts(
        current_sqrt_price,
        lower_sqrt_price,
        upper_sqrt_price,
        amount_a,
        amount_b,
    );

    let (final_amount_a, final_amount_b) = get_amounts_for_liquidity(
        current_sqrt_price,
        lower_sqrt_price,
        upper_sqrt_price,
        dl,
        true, // round up
    );

    let mut fix_coin_a = true;
    if (
        final_amount_a == amount_a || final_amount_a == amount_a + 1 || final_amount_a + 1 == amount_a
    ) fix_coin_a = true else fix_coin_a = false;

    (fix_coin_a, final_amount_a, final_amount_b)
}

fun sort_sqrt_prices(sqrt_price_1: u128, sqrt_price_2: u128): (u128, u128) {
    if (sqrt_price_1 > sqrt_price_2) {
        (sqrt_price_2, sqrt_price_1)
    } else {
        (sqrt_price_1, sqrt_price_2)
    }
}
