module mmt_v3::app;

use mmt_v3::constants;
use sui::dynamic_field as df;
use sui::event;

public struct AdminCap has key, store {
    id: UID,
}

public struct Acl has key {
    id: UID,
}

public struct SetPoolAdminEvent has copy, drop, store {
    sender: address,
    pool_admin: address,
}

public struct SetRewarderAdminEvent has copy, drop, store {
    sender: address,
    rewarder_admin: address,
}

fun init(tx_context: &mut TxContext) {
    let admin_cap = AdminCap { id: object::new(tx_context) };
    transfer::transfer<AdminCap>(admin_cap, tx_context::sender(tx_context));

    let mut acl = Acl { id: object::new(tx_context) };

    // set default rights to package deployer.
    df::add(&mut acl.id, constants::rewarder_admin_df_key(), tx_context::sender(tx_context));
    df::add(&mut acl.id, constants::pool_admin_df_key(), tx_context::sender(tx_context));

    transfer::share_object<Acl>(acl);
}

public fun set_rewarder_admin(_: &AdminCap, acl: &mut Acl, val: address, ctx: &mut TxContext) {
    let old_val = df::borrow_mut<u64, address>(&mut acl.id, constants::rewarder_admin_df_key());
    *old_val = val;
    let set_rewarder_admin_event = SetRewarderAdminEvent {
        sender: tx_context::sender(ctx),
        rewarder_admin: val,
    };
    event::emit(set_rewarder_admin_event);
}

public fun set_pool_admin(_: &AdminCap, acl: &mut Acl, val: address, ctx: &mut TxContext) {
    let old_val = df::borrow_mut<u64, address>(&mut acl.id, constants::pool_admin_df_key());
    *old_val = val;
    let set_pool_admin_event = SetPoolAdminEvent {
        sender: tx_context::sender(ctx),
        pool_admin: val,
    };
    event::emit(set_pool_admin_event);
}

public fun get_rewarder_admin(acl: &Acl): address {
    *df::borrow<u64, address>(&acl.id, constants::rewarder_admin_df_key())
}

public fun get_pool_admin(acl: &Acl): address {
    *df::borrow<u64, address>(&acl.id, constants::pool_admin_df_key())
}

#[test_only]
public fun create_for_testing(ctx: &mut TxContext): AdminCap {
    AdminCap {
        id: object::new(ctx),
    }
}

#[test_only]
public fun destroy_for_testing(admin_cap: AdminCap) {
    let AdminCap { id } = admin_cap;
    object::delete(id);
}

#[test_only]
public fun create_acl_for_testing(ctx: &mut TxContext): Acl {
    let mut acl = Acl {
        id: object::new(ctx),
    };
    df::add(&mut acl.id, constants::rewarder_admin_df_key(), tx_context::sender(ctx));
    df::add(&mut acl.id, constants::pool_admin_df_key(), tx_context::sender(ctx));
    acl
}

#[test_only]
public fun destroy_acl_for_testing(acl: Acl) {
    let Acl { id } = acl;
    object::delete(id);
}

#[test_only]
public fun call_init_for_test(ctx: &mut TxContext) {
    init(ctx);
}
