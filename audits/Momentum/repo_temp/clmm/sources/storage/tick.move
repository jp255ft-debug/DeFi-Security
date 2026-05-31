module mmt_v3::tick;

use mmt_v3::error;
use mmt_v3::i128::I128;
use mmt_v3::i32::I32;
use mmt_v3::i64::I64;
use mmt_v3::tick_math;
use sui::table::{Self, Table};

public struct TickInfo has copy, drop, store {
    liquidity_gross: u128,
    liquidity_net: I128,
    fee_growth_outside_x: u128,
    fee_growth_outside_y: u128,
    reward_growths_outside: vector<u128>,
    tick_cumulative_out_side: I64,
    seconds_per_liquidity_out_side: u256,
    seconds_out_side: u64,
}

// --- Public Functions ---

public fun check_tick_range(
    tick_lower: I32,
    tick_upper: I32,
    tick_spacing: u32,
    min_tick_range_factor: u32,
) {
    let min_tick_range = mmt_v3::i32::mul(
        mmt_v3::i32::from(min_tick_range_factor),
        mmt_v3::i32::from(tick_spacing),
    );
    let tick_range = mmt_v3::i32::sub(tick_upper, tick_lower);
    assert!(mmt_v3::i32::gte(tick_range, min_tick_range), error::invalid_tick_range())
}

// assert ticks
public fun verify_tick(tick_lower: I32, tick_upper: I32, tick_spacing: u32) {
    assert!(
        (mmt_v3::i32::abs_u32(tick_lower) % tick_spacing == 0 && mmt_v3::i32::abs_u32(tick_upper) % tick_spacing == 0) &&
            mmt_v3::i32::lt(tick_lower, tick_upper) &&
            mmt_v3::i32::gte(tick_lower, tick_math::min_tick()) &&
            mmt_v3::i32::lte(tick_upper, tick_math::max_tick()),
        error::invalid_tick(),
    );
}

public fun get_fee_and_reward_growths_inside(
    tick_table: &Table<I32, TickInfo>,
    tick_lower: I32,
    tick_upper: I32,
    current_tick: I32,
    fee_growth_global_x: u128,
    fee_growth_global_y: u128,
    reward_growths: vector<u128>,
): (u128, u128, vector<u128>) {
    let (
        fee_growth_outside_lower_x,
        fee_growth_outside_lower_y,
        reward_growths_outside_lower,
    ) = get_fee_and_reward_growths_outside(tick_table, tick_lower);
    let (
        fee_growth_outside_upper_x,
        fee_growth_outside_upper_y,
        reward_growths_outside_upper,
    ) = get_fee_and_reward_growths_outside(tick_table, tick_upper);

    let (fee_growth_inside_lower_x, fee_growth_inside_lower_y, reward_growths_inside_lower) = if (
        mmt_v3::i32::gte(current_tick, tick_lower)
    ) {
        (fee_growth_outside_lower_x, fee_growth_outside_lower_y, reward_growths_outside_lower)
    } else {
        (
            mmt_v3::math_u128::wrapping_sub(fee_growth_global_x, fee_growth_outside_lower_x),
            mmt_v3::math_u128::wrapping_sub(fee_growth_global_y, fee_growth_outside_lower_y),
            compute_reward_growths(reward_growths, reward_growths_outside_lower),
        )
    };

    let (fee_growth_inside_upper_x, fee_growth_inside_upper_y, reward_growths_inside_upper) = if (
        mmt_v3::i32::lt(current_tick, tick_upper)
    ) {
        (fee_growth_outside_upper_x, fee_growth_outside_upper_y, reward_growths_outside_upper)
    } else {
        (
            mmt_v3::math_u128::wrapping_sub(fee_growth_global_x, fee_growth_outside_upper_x),
            mmt_v3::math_u128::wrapping_sub(fee_growth_global_y, fee_growth_outside_upper_y),
            compute_reward_growths(reward_growths, reward_growths_outside_upper),
        )
    };
    (
        mmt_v3::math_u128::wrapping_sub(
            mmt_v3::math_u128::wrapping_sub(fee_growth_global_x, fee_growth_inside_lower_x),
            fee_growth_inside_upper_x,
        ),
        mmt_v3::math_u128::wrapping_sub(
            mmt_v3::math_u128::wrapping_sub(fee_growth_global_y, fee_growth_inside_lower_y),
            fee_growth_inside_upper_y,
        ),
        compute_reward_growths(
            compute_reward_growths(reward_growths, reward_growths_inside_lower),
            reward_growths_inside_upper,
        ),
    )
}

public fun get_fee_and_reward_growths_outside(
    tick_table: &Table<I32, TickInfo>,
    tick_index: I32,
): (u128, u128, vector<u128>) {
    if (!is_initialized(tick_table, tick_index)) {
        (0, 0, vector::empty<u128>())
    } else {
        let tick_info = table::borrow<I32, TickInfo>(tick_table, tick_index);
        (
            tick_info.fee_growth_outside_x,
            tick_info.fee_growth_outside_y,
            tick_info.reward_growths_outside,
        )
    }
}

public fun get_liquidity_gross(tick_table: &Table<I32, TickInfo>, tick_index: I32): u128 {
    if (!is_initialized(tick_table, tick_index)) {
        0
    } else {
        table::borrow<I32, TickInfo>(tick_table, tick_index).liquidity_gross
    }
}

public fun get_liquidity_net(tick_table: &Table<I32, TickInfo>, tick_index: I32): I128 {
    if (!is_initialized(tick_table, tick_index)) {
        mmt_v3::i128::zero()
    } else {
        table::borrow<I32, TickInfo>(tick_table, tick_index).liquidity_net
    }
}

public fun get_seconds_out_side(tick_table: &Table<I32, TickInfo>, tick_index: I32): u64 {
    if (!is_initialized(tick_table, tick_index)) {
        0
    } else {
        table::borrow<I32, TickInfo>(tick_table, tick_index).seconds_out_side
    }
}

public fun get_seconds_per_liquidity_out_side(
    tick_table: &Table<I32, TickInfo>,
    tick_index: I32,
): u256 {
    if (!is_initialized(tick_table, tick_index)) {
        0
    } else {
        table::borrow<I32, TickInfo>(tick_table, tick_index).seconds_per_liquidity_out_side
    }
}

public fun get_tick_cumulative_out_side(tick_table: &Table<I32, TickInfo>, tick_index: I32): I64 {
    if (!is_initialized(tick_table, tick_index)) {
        mmt_v3::i64::zero()
    } else {
        table::borrow<I32, TickInfo>(tick_table, tick_index).tick_cumulative_out_side
    }
}

public fun is_initialized(tick_table: &Table<I32, TickInfo>, tick_index: I32): bool {
    table::contains<I32, TickInfo>(tick_table, tick_index)
}

public fun tick_spacing_to_max_liquidity_per_tick(tick_spacing: u32): u128 {
    let tick_spacing_i32 = mmt_v3::i32::from(tick_spacing);
    mmt_v3::constants::max_u128() / ((mmt_v3::i32::as_u32(mmt_v3::i32::div(mmt_v3::i32::sub(mmt_v3::i32::mul(mmt_v3::i32::div(tick_math::max_tick(), tick_spacing_i32), tick_spacing_i32), mmt_v3::i32::mul(mmt_v3::i32::div(tick_math::min_tick(), tick_spacing_i32), tick_spacing_i32)), tick_spacing_i32)) + 1) as u128)
}

// --- Friend Functions ---

// returns if tick index becomes empty.
public(package) fun update(
    tick_table: &mut Table<I32, TickInfo>,
    tick_index: I32, // can be lower & upper tick
    current_tick_index: I32,
    liquidity_delta: I128,
    fee_growth_global_x: u128,
    fee_growth_global_y: u128,
    reward_growths: vector<u128>,
    seconds_per_liquidity: u256,
    tick_cumulative: I64,
    seconds: u64,
    is_upper_tick: bool,
    max_liquidity: u128,
): bool {
    // [1] update liquidity gross
    // [2] update liquidity net

    let tick_info = try_borrow_mut_tick(tick_table, tick_index);

    // add delta liquidity to liquidity gross.
    let liquidity_gross_before = tick_info.liquidity_gross;
    let liquidity_gross_after = mmt_v3::liquidity_math::add_delta(
        liquidity_gross_before,
        liquidity_delta,
    );

    assert!(liquidity_gross_after <= max_liquidity, error::exceed_max_liquidity_per_tick());

    // if new tick
    if (liquidity_gross_before == 0) {
        // tick_index < current_tick_index
        if (mmt_v3::i32::lte(tick_index, current_tick_index)) {
            // initialise tick_info with default values.
            tick_info.fee_growth_outside_x = fee_growth_global_x;
            tick_info.fee_growth_outside_y = fee_growth_global_y;
            tick_info.seconds_per_liquidity_out_side = seconds_per_liquidity;
            tick_info.tick_cumulative_out_side = tick_cumulative;
            tick_info.seconds_out_side = seconds;
            tick_info.reward_growths_outside = reward_growths;
        } else {
            // tick_index > current_tick_index
            // position is out of range, hence to clear tick, reset reward growth data.
            let mut reward_index = 0;
            while (reward_index < vector::length<u128>(&reward_growths)) {
                vector::push_back<u128>(&mut tick_info.reward_growths_outside, 0);
                reward_index = reward_index + 1;
            };
        };
    };
    // update liquidity gross with new value.
    tick_info.liquidity_gross = liquidity_gross_after;

    // update liquidity net
    let liquidity_net_after = if (is_upper_tick) {
        mmt_v3::i128::sub(tick_info.liquidity_net, liquidity_delta)
    } else {
        mmt_v3::i128::add(tick_info.liquidity_net, liquidity_delta)
    };
    tick_info.liquidity_net = liquidity_net_after;

    // return is_tick_flip flag,
    //  if any one of before/after equals zero, then flip bitmap index must be flipped.
    // else dont flip(active tick already)
    (liquidity_gross_after == 0) != (liquidity_gross_before == 0)
}

public(package) fun clear(tick_table: &mut Table<I32, TickInfo>, tick_index: I32) {
    table::remove<I32, TickInfo>(tick_table, tick_index);
}

public(package) fun cross(
    tick_table: &mut Table<I32, TickInfo>,
    tick_index: I32,
    fee_growth_global_x: u128,
    fee_growth_global_y: u128,
    reward_growths: vector<u128>,
    seconds_per_liquidity: u256,
    tick_cumulative: I64,
    seconds: u64,
): I128 {
    let tick_info = try_borrow_mut_tick(tick_table, tick_index);
    tick_info.fee_growth_outside_x =
        mmt_v3::math_u128::wrapping_sub(fee_growth_global_x, tick_info.fee_growth_outside_x);
    tick_info.fee_growth_outside_y =
        mmt_v3::math_u128::wrapping_sub(fee_growth_global_y, tick_info.fee_growth_outside_y);
    tick_info.reward_growths_outside =
        compute_reward_growths(reward_growths, tick_info.reward_growths_outside);
    tick_info.seconds_per_liquidity_out_side =
        seconds_per_liquidity - tick_info.seconds_per_liquidity_out_side;
    tick_info.tick_cumulative_out_side =
        mmt_v3::i64::sub(tick_cumulative, tick_info.tick_cumulative_out_side);
    tick_info.seconds_out_side = seconds - tick_info.seconds_out_side;
    tick_info.liquidity_net
}

// --- Private Functions ---

fun compute_reward_growths(
    reward_growths_global: vector<u128>,
    reward_growths_outside: vector<u128>,
): vector<u128> {
    let mut reward_index = 0;
    let mut reward_growths_inside = vector::empty<u128>();
    while (reward_index < vector::length<u128>(&reward_growths_global)) {
        let reward_growth_outside = if (
            reward_index >= vector::length<u128>(&reward_growths_outside)
        ) {
            0
        } else {
            let reward_outside_value = vector::borrow<u128>(&reward_growths_outside, reward_index);
            *reward_outside_value
        };
        vector::push_back<u128>(
            &mut reward_growths_inside,
            mmt_v3::math_u128::wrapping_sub(
                *vector::borrow<u128>(&reward_growths_global, reward_index),
                reward_growth_outside,
            ),
        );
        reward_index = reward_index + 1;
    };
    reward_growths_inside
}

fun try_borrow_mut_tick(tick_table: &mut Table<I32, TickInfo>, tick_index: I32): &mut TickInfo {
    if (!table::contains<I32, TickInfo>(tick_table, tick_index)) {
        let new_tick_info = TickInfo {
            liquidity_gross: 0,
            liquidity_net: mmt_v3::i128::zero(),
            fee_growth_outside_x: 0,
            fee_growth_outside_y: 0,
            reward_growths_outside: vector::empty<u128>(),
            tick_cumulative_out_side: mmt_v3::i64::zero(),
            seconds_per_liquidity_out_side: 0,
            seconds_out_side: 0,
        };
        table::add<I32, TickInfo>(tick_table, tick_index, new_tick_info);
    };
    table::borrow_mut<I32, TickInfo>(tick_table, tick_index)
}
