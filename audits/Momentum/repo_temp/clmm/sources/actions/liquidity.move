module mmt_v3::liquidity;

use mmt_v3::error;
use mmt_v3::i32::I32;
use mmt_v3::pool::{Self, Pool};
use mmt_v3::position::{Self, Position};
use mmt_v3::version::{Self, Version};
use sui::balance;
use sui::clock::Clock;
use sui::coin::{Self, Coin};
use sui::event;

public struct OpenPositionEvent has copy, drop, store {
    sender: address,
    pool_id: ID,
    position_id: ID,
    tick_lower_index: I32,
    tick_upper_index: I32,
}

public struct ClosePositionEvent has copy, drop, store {
    sender: address,
    position_id: ID,
}

public struct AddLiquidityEvent has copy, drop, store {
    sender: address,
    pool_id: ID,
    position_id: ID,
    liquidity: u128,
    amount_x: u64,
    amount_y: u64,
    upper_tick_index: I32,
    lower_tick_index: I32,
    reserve_x: u64,
    reserve_y: u64,
}

public struct RemoveLiquidityEvent has copy, drop, store {
    sender: address,
    pool_id: ID,
    position_id: ID,
    liquidity: u128,
    amount_x: u64,
    amount_y: u64,
    upper_tick_index: I32,
    lower_tick_index: I32,
    reserve_x: u64,
    reserve_y: u64,
}

public fun open_position<X, Y>(
    pool: &mut Pool<X, Y>,
    tick_lower: I32,
    tick_upper: I32,
    version: &Version,
    ctx: &mut TxContext,
): Position {
    version::assert_supported_version(version);
    pool::assert_not_pause(pool);
    mmt_v3::tick::verify_tick(tick_lower, tick_upper, pool::tick_spacing<X, Y>(pool));
    mmt_v3::tick::check_tick_range(
        tick_lower,
        tick_upper,
        pool::tick_spacing<X, Y>(pool),
        pool::min_tick_range_factor<X, Y>(pool),
    );

    let position = position::open(
        object::id<Pool<X, Y>>(pool),
        pool::swap_fee_rate<X, Y>(pool),
        pool::type_x<X, Y>(pool),
        pool::type_y<X, Y>(pool),
        tick_lower,
        tick_upper,
        ctx,
    );

    let open_event = OpenPositionEvent {
        sender: tx_context::sender(ctx),
        pool_id: object::id<Pool<X, Y>>(pool),
        position_id: object::id<Position>(&position),
        tick_lower_index: tick_lower,
        tick_upper_index: tick_upper,
    };
    event::emit<OpenPositionEvent>(open_event);

    position
}

public fun close_position(position: Position, version: &Version, ctx: &TxContext) {
    version::assert_supported_version(version);
    assert!(position::is_empty(&position), error::position_not_empty());

    let event = ClosePositionEvent {
        sender: tx_context::sender(ctx),
        position_id: object::id<Position>(&position),
    };
    event::emit<ClosePositionEvent>(event);
    position::close(position);
}

public fun remove_liquidity<X, Y>(
    pool: &mut Pool<X, Y>,
    position: &mut Position,
    liquidity: u128,
    min_amount_x: u64,
    min_amount_y: u64,
    clock: &Clock,
    version: &Version,
    ctx: &mut TxContext,
): (Coin<X>, Coin<Y>) {
    version::assert_supported_version(version);
    pool::assert_not_pause(pool);

    // remove liquidity and update data on pool.
    let (balance_x, balance_y) = pool::remove_liquidity<X, Y>(
        pool,
        position,
        mmt_v3::i128::neg_from(liquidity),
        clock,
    );

    // check slippage
    assert!(
        balance::value(&balance_x) >= min_amount_x && 
            balance::value(&balance_y) >= min_amount_y,
        error::high_slippage(),
    );
    let (reserve_x, reserve_y) = pool::reserves(pool);

    let event = RemoveLiquidityEvent {
        sender: tx_context::sender(ctx),
        pool_id: object::id<Pool<X, Y>>(pool),
        position_id: object::id<Position>(position),
        liquidity: liquidity,
        amount_x: balance::value(&balance_x),
        amount_y: balance::value(&balance_y),
        upper_tick_index: position::tick_upper_index(position),
        lower_tick_index: position::tick_lower_index(position),
        reserve_x: reserve_x,
        reserve_y: reserve_y,
    };
    event::emit<RemoveLiquidityEvent>(event);

    (coin::from_balance(balance_x, ctx), coin::from_balance(balance_y, ctx))
}

// adds liquidity and returns refund amount if any.
public fun add_liquidity<X, Y>(
    pool: &mut Pool<X, Y>,
    position: &mut Position,
    coin_x: Coin<X>,
    coin_y: Coin<Y>,
    min_amount_x: u64,
    min_amount_y: u64,
    clock: &Clock,
    version: &Version,
    ctx: &mut TxContext,
): (Coin<X>, Coin<Y>) {
    version::assert_supported_version(version);
    pool::assert_not_pause(pool);
    mmt_v3::tick::check_tick_range(
        position::tick_lower_index(position),
        position::tick_upper_index(position),
        pool::tick_spacing<X, Y>(pool),
        pool::min_tick_range_factor<X, Y>(pool),
    );

    // add liquidity, update position & update treasury
    let (delta_x, delta_y, delta_l, refund_x, refund_y) = pool::add_liquidity<X, Y>(
        pool,
        position,
        coin::into_balance<X>(coin_x),
        coin::into_balance<Y>(coin_y),
        clock,
    );

    // check slippage
    assert!(delta_x >= min_amount_x && delta_y >= min_amount_y, error::high_slippage());
    let (reserve_x, reserve_y) = pool::reserves(pool);
    let increase_event = AddLiquidityEvent {
        sender: tx_context::sender(ctx),
        pool_id: object::id<Pool<X, Y>>(pool),
        position_id: object::id<Position>(position),
        liquidity: delta_l,
        amount_x: delta_x,
        amount_y: delta_y,
        upper_tick_index: position::tick_upper_index(position),
        lower_tick_index: position::tick_lower_index(position),
        reserve_x: reserve_x,
        reserve_y: reserve_y,
    };
    event::emit<AddLiquidityEvent>(increase_event);

    // return refund coins if any
    (coin::from_balance(refund_x, ctx), coin::from_balance(refund_y, ctx))
}
