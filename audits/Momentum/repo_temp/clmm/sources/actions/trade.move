module mmt_v3::trade;

use mmt_v3::constants;
use mmt_v3::error;
use mmt_v3::full_math_u128;
use mmt_v3::full_math_u64;
use mmt_v3::i32::{Self, I32};
use mmt_v3::liquidity_math;
use mmt_v3::oracle;
use mmt_v3::pool::{Self, Pool};
use mmt_v3::position::{Self, Position};
use mmt_v3::tick;
use mmt_v3::tick_bitmap;
use mmt_v3::tick_math;
use mmt_v3::utils;
use mmt_v3::version::{Self, Version};
use sui::balance::Balance;
use sui::clock::{Self, Clock};
use sui::event;

const Factor: u128 = 18446744073709551616; // 2^64 (64 bit notation)

// FlashLoanEvent flash_swap & loan receipt hot potatoes.
public struct FlashSwapReceipt {
    pool_id: ID,
    amount_x_debt: u64,
    amount_y_debt: u64,
}

public struct FlashLoanReceipt {
    pool_id: ID,
    amount_x: u64,
    amount_y: u64,
    fee_x: u64,
    fee_y: u64,
}

// flash_swap state & computations structs
public struct SwapState has copy, drop {
    amount_specified_remaining: u64,
    amount_calculated: u64,
    sqrt_price: u128,
    tick_index: I32,
    fee_growth_global: u128,
    protocol_fee: u64,
    liquidity: u128,
    fee_amount: u64,
}

public struct SwapStepComputations has copy, drop {
    sqrt_price_start: u128,
    tick_index_next: i32::I32,
    initialized: bool,
    sqrt_price_next: u128,
    amount_in: u64,
    amount_out: u64,
    fee_amount: u64,
}

// Events
public struct SwapEvent has copy, drop, store {
    sender: address,
    pool_id: ID,
    x_for_y: bool,
    amount_x: u64,
    amount_y: u64,
    sqrt_price_before: u128,
    sqrt_price_after: u128,
    liquidity: u128,
    tick_index: i32::I32,
    fee_amount: u64,
    protocol_fee: u64,
    reserve_x: u64,
    reserve_y: u64,
}

public struct RepayFlashLoanEvent has copy, drop, store {
    sender: address,
    pool_id: ID,
    amount_x_debt: u64,
    amount_y_debt: u64,
    actual_fee_paid_x: u64,
    actual_fee_paid_y: u64,
    reserve_x: u64,
    reserve_y: u64,
    fee_x: u64,
    fee_y: u64,
}

public struct RepayFlashSwapEvent has copy, drop, store {
    sender: address,
    pool_id: ID,
    amount_x_debt: u64,
    amount_y_debt: u64,
    paid_x: u64,
    paid_y: u64,
    reserve_x: u64,
    reserve_y: u64,
}

public struct FlashLoanEvent has copy, drop, store {
    sender: address,
    pool_id: ID,
    amount_x: u64,
    amount_y: u64,
    reserve_x: u64,
    reserve_y: u64,
}

public fun flash_swap<X, Y>(
    pool: &mut Pool<X, Y>,
    is_x_to_y: bool,
    exact_input: bool,
    amount_specified: u64,
    sqrt_price_limit: u128,
    clock: &Clock,
    version: &Version,
    ctx: &TxContext,
): (Balance<X>, Balance<Y>, FlashSwapReceipt) {
    version::assert_supported_version(version);
    pool::assert_trading_enabled(pool);
    pool::assert_not_pause(pool);

    validate_sqrt_price_limit(pool, sqrt_price_limit, is_x_to_y);
    let before_sqrt_price = pool::sqrt_price(pool);

    let fee_growth_global = if (is_x_to_y) {
        pool::fee_growth_global_x(pool)
    } else {
        pool::fee_growth_global_y(pool)
    };
    let mut swap_state = SwapState {
        amount_specified_remaining: amount_specified,
        amount_calculated: 0,
        sqrt_price: pool::sqrt_price(pool),
        tick_index: pool::tick_index_current(pool),
        fee_growth_global: fee_growth_global,
        protocol_fee: 0,
        liquidity: pool::liquidity(pool),
        fee_amount: 0,
    };

    while (
        swap_state.amount_specified_remaining != 0 && swap_state.sqrt_price != sqrt_price_limit
    ) {
        let mut swap_step = SwapStepComputations {
            sqrt_price_start: 0,
            tick_index_next: i32::zero(),
            initialized: false,
            sqrt_price_next: 0,
            amount_in: 0,
            amount_out: 0,
            fee_amount: 0,
        };

        // update next tick & sqrt prices
        swap_step.sqrt_price_start = swap_state.sqrt_price;
        let (
            next_tick_index,
            initialized,
        ) = mmt_v3::tick_bitmap::next_initialized_tick_within_one_word(
            pool::borrow_tick_bitmap(pool),
            swap_state.tick_index,
            pool::tick_spacing(pool),
            is_x_to_y,
        );
        swap_step.tick_index_next = next_tick_index;
        swap_step.initialized = initialized;
        if (i32::lt(swap_step.tick_index_next, tick_math::min_tick())) {
            swap_step.tick_index_next = tick_math::min_tick();
        } else {
            if (i32::gt(swap_step.tick_index_next, tick_math::max_tick())) {
                swap_step.tick_index_next = tick_math::max_tick();
            };
        };
        swap_step.sqrt_price_next = tick_math::get_sqrt_price_at_tick(swap_step.tick_index_next);
        let sqrt_price_target = if (is_x_to_y) {
            mmt_v3::math_u128::max(swap_step.sqrt_price_next, sqrt_price_limit)
        } else {
            mmt_v3::math_u128::min(swap_step.sqrt_price_next, sqrt_price_limit)
        };

        // calc amount out amount.
        let (
            new_sqrt_price,
            amount_in,
            amount_out,
            fee_amount,
        ) = mmt_v3::swap_math::compute_swap_step(
            swap_state.sqrt_price,
            sqrt_price_target,
            swap_state.liquidity,
            swap_state.amount_specified_remaining,
            pool::swap_fee_rate(pool),
            exact_input,
        );
        swap_state.sqrt_price = new_sqrt_price;
        swap_step.amount_in = amount_in;
        swap_step.amount_out = amount_out;
        swap_step.fee_amount = fee_amount;

        // udpate amount remaining & calculated.
        if (exact_input) {
            swap_state.amount_specified_remaining =
                swap_state.amount_specified_remaining - (swap_step.amount_in + swap_step.fee_amount);
            swap_state.amount_calculated = swap_state.amount_calculated + swap_step.amount_out;
        } else {
            swap_state.amount_specified_remaining =
                swap_state.amount_specified_remaining - swap_step.amount_out;
            swap_state.amount_calculated =
                swap_state.amount_calculated + swap_step.amount_in + swap_step.fee_amount;
        };

        // update protocol fee
        if ((pool::protocol_fee_share(pool)) > 0) {
            let protocol_fee_share = full_math_u64::mul_div_floor(
                swap_step.fee_amount,
                pool::protocol_fee_share(pool),
                constants::protocol_fee_share_denominator(),
            );
            swap_step.fee_amount = swap_step.fee_amount - protocol_fee_share;
            swap_state.protocol_fee = swap_state.protocol_fee + protocol_fee_share;
        };
        if (swap_state.liquidity > 0) {
            swap_state.fee_growth_global =
                mmt_v3::math_u128::wrapping_add(
                    swap_state.fee_growth_global,
                    mmt_v3::full_math_u128::mul_div_floor(
                        swap_step.fee_amount as u128,
                        mmt_v3::constants::q64() as u128,
                        swap_state.liquidity,
                    ),
                );
        };
        swap_state.fee_amount = swap_state.fee_amount + swap_step.fee_amount;

        // update liquidity
        if (swap_state.sqrt_price == swap_step.sqrt_price_next) {
            let (fee_growth_x, fee_growth_y) = if (is_x_to_y) {
                (swap_state.fee_growth_global, pool::fee_growth_global_y(pool))
            } else {
                (pool::fee_growth_global_x(pool), swap_state.fee_growth_global)
            };

            if (swap_step.initialized) {
                let (tick_cumulative, seconds_per_liquidity_cumulative) = oracle::observe_single(
                    pool::borrow_observations(pool),
                    utils::to_seconds(clock::timestamp_ms(clock)),
                    0,
                    pool::tick_index_current(pool),
                    pool::observation_index(pool),
                    pool::liquidity(pool),
                    pool::observation_cardinality(pool),
                );
                let reward_info = pool::update_reward_infos<X, Y>(
                    pool,
                    utils::to_seconds(clock::timestamp_ms(clock)),
                );
                let liquidity_delta = mmt_v3::tick::cross(
                    pool::ticks_mut(pool),
                    swap_step.tick_index_next,
                    fee_growth_x,
                    fee_growth_y,
                    reward_info,
                    seconds_per_liquidity_cumulative,
                    tick_cumulative,
                    utils::to_seconds(clock::timestamp_ms(clock)),
                );
                let mut liquidity_change = liquidity_delta;
                if (is_x_to_y) {
                    liquidity_change = mmt_v3::i128::neg(liquidity_delta);
                };
                swap_state.liquidity =
                    mmt_v3::liquidity_math::add_delta(swap_state.liquidity, liquidity_change);
            };
            let new_tick_index = if (is_x_to_y) {
                i32::sub(swap_step.tick_index_next, i32::from(1))
            } else {
                swap_step.tick_index_next
            };
            swap_state.tick_index = new_tick_index;
            continue
        };

        if (swap_state.sqrt_price != swap_step.sqrt_price_start) {
            swap_state.tick_index = tick_math::get_tick_at_sqrt_price(swap_state.sqrt_price);
            continue
        };
    };

    // if price updated, write to oracle
    if (!i32::eq(swap_state.tick_index, pool::tick_index_current(pool))) {
        let observation_index = pool::observation_index(pool);
        let tick_index_current = pool::tick_index_current(pool);
        let liquidity = pool::liquidity(pool);
        let observation_cardinality = pool::observation_cardinality(pool);
        let observation_cardinality_next = pool::observation_cardinality_next(pool);
        let (new_observation_index, new_observation_cardinality) = oracle::write(
            pool::observations_mut(pool),
            observation_index,
            utils::to_seconds(clock::timestamp_ms(clock)),
            tick_index_current,
            liquidity,
            observation_cardinality,
            observation_cardinality_next,
        );
        pool::set_sqrt_price(pool, swap_state.sqrt_price);
        pool::set_tick_index_current(pool, swap_state.tick_index);
        pool::set_observation_index(pool, new_observation_index);
        pool::set_observation_cardinality(pool, new_observation_cardinality);
    } else {
        pool::set_sqrt_price(pool, swap_state.sqrt_price);
    };

    if (pool::liquidity(pool) != swap_state.liquidity) {
        pool::set_liquidity(pool, swap_state.liquidity);
    };

    // update fee growth globals based on collected fees.
    if (is_x_to_y) {
        pool::set_fee_growth_global_x(pool, swap_state.fee_growth_global);
        let protocol_fee_x = pool::protocol_fee_x(pool);
        pool::set_protocol_fee_x(pool, protocol_fee_x + swap_state.protocol_fee);
    } else {
        pool::set_fee_growth_global_y(pool, swap_state.fee_growth_global);
        let protocol_fee_y = pool::protocol_fee_y(pool);
        pool::set_protocol_fee_y(pool, protocol_fee_y + swap_state.protocol_fee);
    };
    let (amount_x, amount_y) = if (is_x_to_y == exact_input) {
        (amount_specified - swap_state.amount_specified_remaining, swap_state.amount_calculated)
    } else {
        (swap_state.amount_calculated, amount_specified - swap_state.amount_specified_remaining)
    };
    let (balance_x, balance_y, swap_receipt) = if (is_x_to_y) {
        let receipt = FlashSwapReceipt {
            pool_id: object::id<Pool<X, Y>>(pool),
            amount_x_debt: amount_x,
            amount_y_debt: 0,
        };
        let (balance_x, balance_y) = pool::take_from_reserves<X, Y>(pool, 0, amount_y);
        (balance_x, balance_y, receipt)
    } else {
        let receipt = FlashSwapReceipt {
            pool_id: object::id<Pool<X, Y>>(pool),
            amount_x_debt: 0,
            amount_y_debt: amount_y,
        };
        let (balance_x, balance_y) = pool::take_from_reserves<X, Y>(pool, amount_x, 0);
        (balance_x, balance_y, receipt)
    };

    let (reserve_x, reserve_y) = pool::reserves(pool);
    let swap_event = SwapEvent {
        sender: tx_context::sender(ctx),
        pool_id: object::id<Pool<X, Y>>(pool),
        x_for_y: is_x_to_y,
        amount_x,
        amount_y,
        sqrt_price_before: before_sqrt_price,
        sqrt_price_after: swap_state.sqrt_price,
        liquidity: swap_state.liquidity,
        tick_index: swap_state.tick_index,
        fee_amount: swap_state.fee_amount,
        protocol_fee: swap_state.protocol_fee,
        reserve_x: reserve_x,
        reserve_y: reserve_y,
    };

    event::emit<SwapEvent>(swap_event);

    (balance_x, balance_y, swap_receipt)
}

public fun repay_flash_swap<X, Y>(
    pool: &mut Pool<X, Y>,
    receipt: FlashSwapReceipt,
    balance_x: Balance<X>,
    balance_y: Balance<Y>,
    version: &Version,
    ctx: &TxContext,
) {
    version::assert_supported_version(version);
    pool::verify_pool<X, Y>(pool, receipt.pool_id);
    pool::assert_not_pause(pool);

    let FlashSwapReceipt {
        pool_id: _,
        amount_x_debt,
        amount_y_debt,
    } = receipt;
    let (initial_reserve_x, initial_reserve_y) = pool::reserves<X, Y>(pool);
    pool::add_to_reserves<X, Y>(pool, balance_x, balance_y);
    let (final_reserve_x, final_reserve_y) = pool::reserves<X, Y>(pool);
    assert!(
        initial_reserve_x + amount_x_debt <= final_reserve_x && initial_reserve_y + amount_y_debt <= final_reserve_y,
        error::invalid_reserves_state(),
    );

    event::emit(RepayFlashSwapEvent {
        sender: tx_context::sender(ctx),
        pool_id: object::id(pool),
        amount_x_debt,
        amount_y_debt,
        paid_x: final_reserve_x - initial_reserve_x,
        paid_y: final_reserve_y - initial_reserve_y,
        reserve_x: final_reserve_x,
        reserve_y: final_reserve_y,
    });
}

public fun flash_loan<X, Y>(
    pool: &mut Pool<X, Y>,
    amount_x: u64,
    amount_y: u64,
    version: &Version,
    ctx: &TxContext,
): (Balance<X>, Balance<Y>, FlashLoanReceipt) {
    version::assert_supported_version(version);
    pool::assert_trading_enabled(pool);
    pool::assert_not_pause(pool);

    assert!(pool::liquidity(pool) > 0, error::insufficient_liquidity());

    let (reserve_x, reserve_y) = pool::get_reserves(pool);
    assert!((amount_x < reserve_x) && (amount_y < reserve_y), error::insufficient_funds());

    let flash_event = FlashLoanEvent {
        sender: tx_context::sender(ctx),
        pool_id: object::id(pool),
        amount_x,
        amount_y,
        reserve_x,
        reserve_y,
    };
    event::emit(flash_event);

    let fee_rate = get_effective_fee_rate(pool);

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
    let flash_receipt = FlashLoanReceipt {
        pool_id: object::id(pool),
        amount_x,
        amount_y,
        fee_x,
        fee_y,
    };

    let (balance_x, balance_y) = pool::take_from_reserves(pool, amount_x, amount_y);
    (balance_x, balance_y, flash_receipt)
}

public fun repay_flash_loan<X, Y>(
    pool: &mut Pool<X, Y>,
    receipt: FlashLoanReceipt,
    balance_x: Balance<X>,
    balance_y: Balance<Y>,
    version: &Version,
    ctx: &TxContext,
) {
    version::assert_supported_version(version);
    pool::verify_pool<X, Y>(pool, receipt.pool_id);
    pool::assert_not_pause(pool);

    let FlashLoanReceipt {
        pool_id: _,
        amount_x,
        amount_y,
        fee_x,
        fee_y,
    } = receipt;
    let (reserve_x_before, reserve_y_before) = pool::reserves<X, Y>(pool);
    pool::add_to_reserves<X, Y>(pool, balance_x, balance_y);
    let (reserve_x_after, reserve_y_after) = pool::reserves<X, Y>(pool);

    assert!(
        reserve_x_before + amount_x + fee_x <= reserve_x_after && 
            reserve_y_before + amount_y + fee_y <= reserve_y_after,
        error::invalid_reserves_state(),
    );

    let actual_fee_paid_x = reserve_x_after - (reserve_x_before + amount_x);
    let actual_fee_paid_y = reserve_y_after - (reserve_y_before + amount_y);

    if (actual_fee_paid_x > 0) {
        let protocol_fee_x = if (pool::protocol_flash_loan_fee_share(pool) == 0) {
            0
        } else {
            full_math_u64::mul_div_floor(
                actual_fee_paid_x,
                pool::protocol_flash_loan_fee_share(pool),
                constants::protocol_fee_share_denominator(),
            )
        };

        let protocol_fee_x_old = pool::protocol_fee_x(pool);
        let fee_growth_global_x = pool::fee_growth_global_x(pool);
        let liquidity = pool::liquidity(pool);
        pool::set_protocol_fee_x(pool, protocol_fee_x_old + protocol_fee_x);
        pool::set_fee_growth_global_x(
            pool,
            mmt_v3::math_u128::wrapping_add(
                fee_growth_global_x,
                full_math_u128::mul_div_floor(
                    ((actual_fee_paid_x - protocol_fee_x) as u128),
                    (constants::q64() as u128),
                    liquidity,
                ),
            ),
        );
    };
    if (actual_fee_paid_y > 0) {
        let protocol_fee_y = if (pool::protocol_flash_loan_fee_share(pool) == 0) {
            0
        } else {
            full_math_u64::mul_div_floor(
                actual_fee_paid_y,
                pool::protocol_flash_loan_fee_share(pool),
                constants::protocol_fee_share_denominator(),
            )
        };
        let protocol_fee_y_old = pool::protocol_fee_y(pool);
        pool::set_protocol_fee_y(pool, protocol_fee_y_old + protocol_fee_y);
        let fee_growth_global_y = pool::fee_growth_global_y(pool);
        let liquidity = pool::liquidity(pool);
        pool::set_fee_growth_global_y(
            pool,
            mmt_v3::math_u128::wrapping_add(
                fee_growth_global_y,
                full_math_u128::mul_div_floor(
                    ((actual_fee_paid_y - protocol_fee_y) as u128),
                    (constants::q64() as u128),
                    liquidity,
                ),
            ),
        );
    };

    event::emit(RepayFlashLoanEvent {
        sender: tx_context::sender(ctx),
        pool_id: object::id(pool),
        amount_x_debt: amount_x + fee_x,
        amount_y_debt: amount_y + fee_y,
        actual_fee_paid_x: actual_fee_paid_x,
        actual_fee_paid_y: actual_fee_paid_y,
        reserve_x: reserve_x_after,
        reserve_y: reserve_y_after,
        fee_x: fee_x,
        fee_y: fee_y,
    });
}

public fun flash_receipt_debts(receipt: &FlashLoanReceipt): (u64, u64) {
    (receipt.amount_x + receipt.fee_x, receipt.amount_y + receipt.fee_y)
}

public fun swap_receipt_debts(receipt: &FlashSwapReceipt): (u64, u64) {
    (receipt.amount_x_debt, receipt.amount_y_debt)
}

public fun compute_swap_result_max<X, Y>(
    pool: &Pool<X, Y>,
    is_x_to_y: bool,
    exact_input: bool,
    sqrt_price_limit: u128,
): SwapState {
    let max_amount = 18446744073709551615;
    let swap_result = compute_swap_result(
        pool,
        is_x_to_y,
        exact_input,
        sqrt_price_limit,
        max_amount,
    );

    swap_result
}

public fun compute_swap_result<X, Y>(
    pool: &Pool<X, Y>,
    is_x_to_y: bool,
    exact_input: bool,
    sqrt_price_limit: u128,
    amount_specified: u64,
): SwapState {
    validate_sqrt_price_limit(pool, sqrt_price_limit, is_x_to_y);

    let fee_growth_global = if (is_x_to_y) {
        pool::fee_growth_global_x(pool)
    } else {
        pool::fee_growth_global_y(pool)
    };

    let mut swap_state = SwapState {
        amount_specified_remaining: amount_specified,
        amount_calculated: 0,
        sqrt_price: pool::sqrt_price(pool),
        tick_index: pool::tick_index_current(pool),
        fee_growth_global: fee_growth_global,
        protocol_fee: 0,
        liquidity: pool::liquidity(pool),
        fee_amount: 0,
    };

    while (
        swap_state.amount_specified_remaining != 0 && swap_state.sqrt_price != sqrt_price_limit
    ) {
        let mut swap_step = SwapStepComputations {
            sqrt_price_start: 0,
            tick_index_next: i32::zero(),
            initialized: false,
            sqrt_price_next: 0,
            amount_in: 0,
            amount_out: 0,
            fee_amount: 0,
        };

        // update next tick & sqrt prices
        swap_step.sqrt_price_start = swap_state.sqrt_price;
        let (next_tick_index, initialized) = tick_bitmap::next_initialized_tick_within_one_word(
            pool::borrow_tick_bitmap(pool),
            swap_state.tick_index,
            pool::tick_spacing(pool),
            is_x_to_y,
        );
        swap_step.tick_index_next = next_tick_index;
        swap_step.initialized = initialized;
        if (i32::lt(swap_step.tick_index_next, tick_math::min_tick())) {
            swap_step.tick_index_next = tick_math::min_tick();
        } else {
            if (i32::gt(swap_step.tick_index_next, tick_math::max_tick())) {
                swap_step.tick_index_next = tick_math::max_tick();
            };
        };
        swap_step.sqrt_price_next = tick_math::get_sqrt_price_at_tick(swap_step.tick_index_next);
        let sqrt_price_target = if (is_x_to_y) {
            mmt_v3::math_u128::max(swap_step.sqrt_price_next, sqrt_price_limit)
        } else {
            mmt_v3::math_u128::min(swap_step.sqrt_price_next, sqrt_price_limit)
        };

        // calc amount out amount.
        let (
            new_sqrt_price,
            amount_in,
            amount_out,
            fee_amount,
        ) = mmt_v3::swap_math::compute_swap_step(
            swap_state.sqrt_price,
            sqrt_price_target,
            swap_state.liquidity,
            swap_state.amount_specified_remaining,
            pool::swap_fee_rate(pool),
            exact_input,
        );
        swap_state.sqrt_price = new_sqrt_price;
        swap_step.amount_in = amount_in;
        swap_step.amount_out = amount_out;
        swap_step.fee_amount = fee_amount;

        // udpate amount remaining & calculated.
        if (exact_input) {
            swap_state.amount_specified_remaining =
                swap_state.amount_specified_remaining - (swap_step.amount_in + swap_step.fee_amount);
            swap_state.amount_calculated = swap_state.amount_calculated + swap_step.amount_out;
        } else {
            swap_state.amount_specified_remaining =
                swap_state.amount_specified_remaining - swap_step.amount_out;
            swap_state.amount_calculated =
                swap_state.amount_calculated + swap_step.amount_in + swap_step.fee_amount;
        };

        // update protocol fee
        if (pool::protocol_fee_share(pool) > 0) {
            let protocol_fee_share = full_math_u64::mul_div_floor(
                swap_step.fee_amount,
                pool::protocol_fee_share(pool),
                constants::protocol_fee_share_denominator(),
            );

            swap_step.fee_amount = swap_step.fee_amount - protocol_fee_share;
            swap_state.protocol_fee = swap_state.protocol_fee + protocol_fee_share;
        };
        if (swap_state.liquidity > 0) {
            swap_state.fee_growth_global =
                mmt_v3::math_u128::wrapping_add(
                    swap_state.fee_growth_global,
                    full_math_u128::mul_div_floor(
                        swap_step.fee_amount as u128,
                        mmt_v3::constants::q64() as u128,
                        swap_state.liquidity,
                    ),
                );
        };
        swap_state.fee_amount = swap_state.fee_amount + swap_step.fee_amount;

        // update liquidity
        if (swap_state.sqrt_price == swap_step.sqrt_price_next) {
            if (swap_step.initialized) {
                let mut liquidity_delta = tick::get_liquidity_net(
                    pool::borrow_ticks(pool),
                    swap_step.tick_index_next,
                );

                if (is_x_to_y) {
                    liquidity_delta = mmt_v3::i128::neg(liquidity_delta);
                };
                swap_state.liquidity =
                    mmt_v3::liquidity_math::add_delta(swap_state.liquidity, liquidity_delta);
            };
            let new_tick_index = if (is_x_to_y) {
                i32::sub(swap_step.tick_index_next, i32::from(1))
            } else {
                swap_step.tick_index_next
            };
            swap_state.tick_index = new_tick_index;
            continue
        };

        if (swap_state.sqrt_price != swap_step.sqrt_price_start) {
            swap_state.tick_index = tick_math::get_tick_at_sqrt_price(swap_state.sqrt_price);
            continue
        };
    };

    swap_state
}

public fun get_optimal_swap_amount_for_single_sided_liquidity<A, B>(
    pool: &Pool<A, B>,
    amount: u64,
    position: &Position,
    sqrt_price_limit: u128,
    is_a: bool,
    max_iterations: u64,
): (u64, bool) {
    pool::verify_pool<A, B>(pool, position::pool_id(position));

    let lower_sqrt_price = tick_math::get_sqrt_price_at_tick(position::tick_lower_index(position));
    let upper_sqrt_price = tick_math::get_sqrt_price_at_tick(position::tick_upper_index(position));
    let (pos_amount_a, pos_amount_b) = liquidity_math::get_amounts_for_liquidity(
        pool::sqrt_price(pool),
        lower_sqrt_price,
        upper_sqrt_price,
        pool::liquidity(pool),
        false,
    );
    let (swap_amt, fix_a) = if (pos_amount_a == 0) {
        // fix coin b
        if (is_a) (amount, false) else (0, false)
    } else if (pos_amount_b == 0) {
        // fix coin a
        if (is_a) (0, true) else (amount, true)
    } else {
        let ratio_scaling = Factor;
        let optimal_ratio =
            ((pos_amount_a as u128) * (ratio_scaling as u128)) / (pos_amount_b as u128);

        let mut iteration = 0;
        let mut low = 0;
        let mut high = amount;
        let mut swap_amount = amount / 2;
        let mut best_swap_amount = swap_amount;
        let mut best_ratio = 0u128;

        while (iteration < max_iterations) {
            let swap_result = compute_swap_result(pool, is_a, true, sqrt_price_limit, swap_amount);
            let amount_out = swap_result.amount_calculated;
            let amount_a_after_swap = if (is_a) amount - swap_amount else amount_out;
            let amount_b_after_swap = if (is_a) amount_out else amount - swap_amount;

            let new_ratio =
                ((amount_a_after_swap as u128) * (ratio_scaling as u128)) / (amount_b_after_swap as u128);
            if (iteration == 0 || closer(new_ratio, best_ratio, optimal_ratio)) {
                best_ratio = new_ratio;
                best_swap_amount = swap_amount;
            };

            let excess_a = new_ratio > optimal_ratio;

            if (excess_a == is_a) {
                low = swap_amount;
            } else {
                high = swap_amount;
            };

            swap_amount = (low + high) / 2;
            iteration = iteration + 1;
        };
        let fix_a = !(best_ratio > optimal_ratio == is_a);
        (best_swap_amount, fix_a)
    };

    (swap_amt, fix_a)
}

// flash_swap state getter & setter functions
public fun get_state_amount_specified(state: &SwapState): u64 { state.amount_specified_remaining }

public fun get_state_amount_calculated(state: &SwapState): u64 { state.amount_calculated }

public fun get_state_sqrt_price(state: &SwapState): u128 { state.sqrt_price }

public fun get_state_tick_index(state: &SwapState): I32 { state.tick_index }

public fun get_state_fee_growth_global(state: &SwapState): u128 { state.fee_growth_global }

public fun get_state_protocol_fee(state: &SwapState): u64 { state.protocol_fee }

public fun get_state_liquidity(state: &SwapState): u128 { state.liquidity }

public fun get_state_fee_amount(state: &SwapState): u64 { state.fee_amount }

// flash_swap step getter & setter functions
public fun get_step_sqrt_price_start(state: &SwapStepComputations): u128 { state.sqrt_price_start }

public fun get_step_tick_index_next(state: &SwapStepComputations): I32 { state.tick_index_next }

public fun get_step_sqrt_price_next(state: &SwapStepComputations): u128 { state.sqrt_price_next }

public fun get_step_initialized(state: &SwapStepComputations): bool { state.initialized }

public fun get_step_amount_in(state: &SwapStepComputations): u64 { state.amount_in }

public fun get_step_amount_out(state: &SwapStepComputations): u64 { state.amount_out }

public fun get_step_fee_amount(state: &SwapStepComputations): u64 { state.fee_amount }

fun closer(a: u128, b: u128, target: u128): bool {
    let diff_a = if (a > target) { a - target } else { target - a };

    let diff_b = if (b > target) { b - target } else { target - b };

    diff_a < diff_b
}

fun validate_sqrt_price_limit<X, Y>(pool: &Pool<X, Y>, sqrt_price_limit: u128, is_x_to_y: bool) {
    let current_sqrt_price = pool::sqrt_price(pool);
    assert!(current_sqrt_price != 0, error::pool_not_initialised());
    if (is_x_to_y) {
        assert!(sqrt_price_limit < current_sqrt_price, error::high_slippage());
        assert!(sqrt_price_limit >= tick_math::min_sqrt_price(), error::invalid_price_limit());
    } else {
        assert!(sqrt_price_limit > current_sqrt_price, error::high_slippage());
        assert!(sqrt_price_limit <= tick_math::max_sqrt_price(), error::invalid_price_limit());
    };
}

public(package) fun get_effective_fee_rate<X, Y>(pool: &Pool<X, Y>): u64 {
    let flash_loan_fee_rate = pool.flash_loan_fee_rate();
    if (flash_loan_fee_rate == 0) {
        pool.swap_fee_rate()
    } else {
        flash_loan_fee_rate
    }
}
