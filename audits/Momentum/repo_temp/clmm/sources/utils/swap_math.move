module mmt_v3::swap_math;

use mmt_v3::constants;
use mmt_v3::full_math_u64;

public fun compute_swap_step(
    current_sqrt_price: u128,
    target_sqrt_price: u128,
    liquidity: u128,
    amount_remaining: u64,
    fee_rate: u64,
    is_exact_input: bool,
): (u128, u64, u64, u64) {
    let is_price_decreasing = current_sqrt_price >= target_sqrt_price;
    let mut amount_in = 0;
    let mut amount_out = 0;
    let next_sqrt_price = if (is_exact_input) {
        let amount_remaining_minus_fee = full_math_u64::mul_div_floor(
            amount_remaining,
            constants::fee_rate_denominator() - fee_rate,
            constants::fee_rate_denominator(),
        );
        let amount_in_delta = if (is_price_decreasing) {
            // pools active liquidity is used agains next_price & current_price.
            // xy = k, (current_price, next_price)
            mmt_v3::sqrt_price_math::get_amount_x_delta(
                target_sqrt_price,
                current_sqrt_price,
                liquidity,
                true,
            )
        } else {
            // pools active liquidity is used agains next_price & current_price.
            // xy = k, (current_price, next_price)
            mmt_v3::sqrt_price_math::get_amount_y_delta(
                current_sqrt_price,
                target_sqrt_price,
                liquidity,
                true,
            )
        };
        amount_in = amount_in_delta;
        let new_sqrt_price = if (amount_remaining_minus_fee >= amount_in_delta) {
            target_sqrt_price
        } else {
            mmt_v3::sqrt_price_math::get_next_sqrt_price_from_input(
                current_sqrt_price,
                liquidity,
                amount_remaining_minus_fee,
                is_price_decreasing,
            )
        };
        new_sqrt_price
    } else {
        let amount_out_delta = if (is_price_decreasing) {
            mmt_v3::sqrt_price_math::get_amount_y_delta(
                target_sqrt_price,
                current_sqrt_price,
                liquidity,
                false,
            )
        } else {
            mmt_v3::sqrt_price_math::get_amount_x_delta(
                current_sqrt_price,
                target_sqrt_price,
                liquidity,
                false,
            )
        };
        amount_out = amount_out_delta;
        let new_sqrt_price = if (amount_remaining >= amount_out_delta) {
            target_sqrt_price
        } else {
            mmt_v3::sqrt_price_math::get_next_sqrt_price_from_output(
                current_sqrt_price,
                liquidity,
                amount_remaining,
                is_price_decreasing,
            )
        };
        new_sqrt_price
    };
    let is_target_reached = target_sqrt_price == next_sqrt_price;
    if (is_price_decreasing) {
        let new_amount_in = if (is_target_reached && is_exact_input) {
            amount_in
        } else {
            mmt_v3::sqrt_price_math::get_amount_x_delta(
                next_sqrt_price,
                current_sqrt_price,
                liquidity,
                true,
            )
        };
        amount_in = new_amount_in;
        let new_amount_out = if (is_target_reached && !is_exact_input) {
            amount_out
        } else {
            mmt_v3::sqrt_price_math::get_amount_y_delta(
                next_sqrt_price,
                current_sqrt_price,
                liquidity,
                false,
            )
        };
        amount_out = new_amount_out;
    } else {
        let new_amount_in = if (is_target_reached && is_exact_input) {
            amount_in
        } else {
            mmt_v3::sqrt_price_math::get_amount_y_delta(
                current_sqrt_price,
                next_sqrt_price,
                liquidity,
                true,
            )
        };
        amount_in = new_amount_in;
        let new_amount_out = if (is_target_reached && !is_exact_input) {
            amount_out
        } else {
            mmt_v3::sqrt_price_math::get_amount_x_delta(
                current_sqrt_price,
                next_sqrt_price,
                liquidity,
                false,
            )
        };
        amount_out = new_amount_out;
    };
    if (!is_exact_input && amount_out > amount_remaining) {
        amount_out = amount_remaining;
    };
    let fee_amount = if (is_exact_input && next_sqrt_price != target_sqrt_price) {
        amount_remaining - amount_in
    } else {
        full_math_u64::mul_div_round(
            amount_in,
            fee_rate,
            constants::fee_rate_denominator() - fee_rate,
        )
    };
    (next_sqrt_price, amount_in, amount_out, fee_amount)
}
