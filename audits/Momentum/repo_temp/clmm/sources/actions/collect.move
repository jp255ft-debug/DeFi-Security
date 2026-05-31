module mmt_v3::collect;

use mmt_v3::pool::{Self, Pool};
use mmt_v3::position::{Self, Position};
use mmt_v3::version::{Self, Version};
use std::type_name::{Self, TypeName};
use sui::balance;
use sui::clock::Clock;
use sui::coin::{Self, Coin};
use sui::event;

public struct FeeCollectedEvent has copy, drop, store {
    sender: address,
    pool_id: ID,
    position_id: ID,
    amount_x: u64,
    amount_y: u64,
}

public struct CollectPoolRewardEvent has copy, drop, store {
    sender: address,
    pool_id: ID,
    position_id: ID,
    reward_coin_type: TypeName,
    amount: u64,
}

public fun fee<X, Y>(
    pool: &mut Pool<X, Y>,
    position: &mut Position,
    clock: &Clock,
    version: &Version,
    tx_context: &mut TxContext,
): (Coin<X>, Coin<Y>) {
    version::assert_supported_version(version);
    pool::assert_not_pause(pool);
    pool::verify_pool<X, Y>(pool, position::pool_id(position));

    if (mmt_v3::position::liquidity(position) > 0) {
        // update fee & reward growth data with zero delta l
        let (_, _) = pool::update_data_for_delta_l<X, Y>(
            pool,
            position,
            mmt_v3::i128::zero(),
            clock,
        );
    };
    let (collected_x, collected_y) = pool::collect_fee<X, Y>(pool, position);
    let event = FeeCollectedEvent {
        sender: tx_context::sender(tx_context),
        pool_id: object::id<pool::Pool<X, Y>>(pool),
        position_id: object::id<Position>(position),
        amount_x: balance::value<X>(&collected_x),
        amount_y: balance::value<Y>(&collected_y),
    };
    event::emit<FeeCollectedEvent>(event);
    (coin::from_balance<X>(collected_x, tx_context), coin::from_balance<Y>(collected_y, tx_context))
}

public fun reward<X, Y, R>(
    pool: &mut Pool<X, Y>,
    position: &mut Position,
    clock: &Clock,
    version: &Version,
    ctx: &mut TxContext,
): Coin<R> {
    version::assert_supported_version(version);
    pool::assert_not_pause(pool);
    pool::verify_pool<X, Y>(pool, position::pool_id(position));

    if (mmt_v3::position::liquidity(position) > 0) {
        // update fee & reward growth data with zero delta l
        let (_, _) = pool::update_data_for_delta_l<X, Y>(
            pool,
            position,
            mmt_v3::i128::zero(),
            clock,
        );
    };

    let reward = pool::collect_reward<X, Y, R>(pool, position);

    event::emit(CollectPoolRewardEvent {
        sender: tx_context::sender(ctx),
        pool_id: object::id(pool),
        position_id: object::id(position),
        reward_coin_type: type_name::get<R>(),
        amount: balance::value(&reward),
    });

    coin::from_balance<R>(reward, ctx)
}
