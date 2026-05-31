module mmt_v3::global_config;

use mmt_v3::app::AdminCap;
use mmt_v3::error;
use sui::event;
use sui::table::{Self, Table};

public struct EnableFeeRateEvent has copy, drop, store {
    sender: address,
    fee_rate: u64,
    tick_spacing: u32,
}

public struct GlobalConfig has key, store {
    id: UID,
    fee_amount_tick_spacing: Table<u64, u32>,
}

fun init(tx_context: &mut TxContext) {
    let mut global_config = GlobalConfig {
        id: object::new(tx_context),
        fee_amount_tick_spacing: table::new<u64, u32>(tx_context),
    };
    enable_fee_rate_internal(&mut global_config, 100, 2, tx_context);
    enable_fee_rate_internal(&mut global_config, 500, 10, tx_context);
    enable_fee_rate_internal(&mut global_config, 3000, 60, tx_context);
    enable_fee_rate_internal(&mut global_config, 10000, 200, tx_context);

    transfer::share_object<GlobalConfig>(global_config);
}

public fun enable_fee_rate(
    _: &AdminCap,
    global_config: &mut GlobalConfig,
    fee_rate: u64,
    tick_spacing: u32,
    tx_context: &TxContext,
) {
    assert!(fee_rate < 1000000, error::invalid_fee_rate());
    assert!(tick_spacing > 0 && tick_spacing < 10000, error::invalid_tick_spacing());
    assert!(!contains_fee_rate(global_config, fee_rate), error::fee_rate_already_configured());

    enable_fee_rate_internal(global_config, fee_rate, tick_spacing, tx_context);
}

public fun contains_fee_rate(self: &GlobalConfig, fee_rate: u64): bool {
    table::contains<u64, u32>(&self.fee_amount_tick_spacing, fee_rate)
}

public fun get_tick_spacing(self: &GlobalConfig, fee_rate: u64): u32 {
    assert!(contains_fee_rate(self, fee_rate), error::invalid_create_pool_configs());
    *table::borrow<u64, u32>(&self.fee_amount_tick_spacing, fee_rate)
}

fun enable_fee_rate_internal(
    global_config: &mut GlobalConfig,
    fee_rate: u64,
    tick_spacing: u32,
    tx_context: &TxContext,
) {
    table::add<u64, u32>(&mut global_config.fee_amount_tick_spacing, fee_rate, tick_spacing);
    let enable_fee_rate_event = EnableFeeRateEvent {
        sender: tx_context::sender(tx_context),
        fee_rate: fee_rate,
        tick_spacing: tick_spacing,
    };
    event::emit<EnableFeeRateEvent>(enable_fee_rate_event);
}

#[test_only]
public fun init_(tx_context: &mut TxContext) {
    let mut global_config = GlobalConfig {
        id: object::new(tx_context),
        fee_amount_tick_spacing: table::new<u64, u32>(tx_context),
    };
    enable_fee_rate_internal(&mut global_config, 100, 2, tx_context);
    enable_fee_rate_internal(&mut global_config, 500, 10, tx_context);
    enable_fee_rate_internal(&mut global_config, 2000, 40, tx_context);
    enable_fee_rate_internal(&mut global_config, 3000, 60, tx_context);
    enable_fee_rate_internal(&mut global_config, 10000, 200, tx_context);

    transfer::share_object<GlobalConfig>(global_config);
}

#[test_only]
public fun call_init_for_test(ctx: &mut TxContext) {
    init(ctx);
}
