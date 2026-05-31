module mmt_v3::create_pool;

use mmt_v3::comparator;
use mmt_v3::constants;
use mmt_v3::error;
use mmt_v3::global_config::{Self, GlobalConfig};
use mmt_v3::pool::{Self, Pool};
use mmt_v3::version::{Self, Version};
use std::bcs;
use std::type_name::{Self, TypeName};
use sui::event;

public struct PoolCreatedEvent has copy, drop, store {
    sender: address,
    pool_id: ID,
    type_x: TypeName,
    type_y: TypeName,
    fee_rate: u64,
    tick_spacing: u32,
}

#[allow(lint(share_owned))]
public fun new<X, Y>(
    global_config: &mut GlobalConfig,
    fee_rate: u64,
    version: &Version,
    tx_context: &mut TxContext,
): Pool<X, Y> {
    create_pool_internal<X, Y>(global_config, fee_rate, version, tx_context)
}

fun create_pool_internal<X, Y>(
    global_config: &GlobalConfig,
    fee_rate: u64,
    version: &Version,
    tx_context: &mut TxContext,
): Pool<X, Y> {
    version::assert_supported_version(version);
    assert!(type_name::get<X>() != type_name::get<Y>(), error::invalid_pool_coin_types());
    assert!(check_coin_order<X, Y>(), error::invalid_pool_coin_types_sorted());
    let tick_spacing = global_config::get_tick_spacing(global_config, fee_rate);
    let new_pool = pool::create<X, Y>(
        tick_spacing,
        fee_rate,
        fee_rate,
        constants::protocol_swap_fee_share(), // protocol swap fee share 20%
        constants::protocol_flash_loan_fee_share(), // protocol_flash_loan_fee_share 20%
        tx_context,
    );

    let pool_created_event = PoolCreatedEvent {
        sender: tx_context::sender(tx_context),
        pool_id: object::id<pool::Pool<X, Y>>(&new_pool),
        type_x: pool::type_x<X, Y>(&new_pool),
        type_y: pool::type_y<X, Y>(&new_pool),
        fee_rate: fee_rate,
        tick_spacing: tick_spacing,
    };
    event::emit<PoolCreatedEvent>(pool_created_event);

    new_pool
}

public fun check_coin_order<X, Y>(): bool {
    let x_name = type_name::get<X>();
    let y_name = type_name::get<Y>();
    let x_bytes = bcs::to_bytes<TypeName>(&x_name);
    let y_bytes = bcs::to_bytes<TypeName>(&y_name);
    let cmp = comparator::compare_u8_vector(x_bytes, y_bytes);
    comparator::is_smaller_than(&cmp)
}
