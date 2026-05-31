#[test_only]
module mmt_v3::app_test;

use mmt_v3::app;
use mmt_v3::test_helper as th;
use sui::test_scenario;

#[test]
public fun set_rewarder_admin() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let admin = app::create_for_testing(test_scenario::ctx(&mut scenario));
    let mut acl = app::create_acl_for_testing(test_scenario::ctx(&mut scenario));

    th::setup(test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);

    app::set_rewarder_admin(&admin, &mut acl, tester1, test_scenario::ctx(&mut scenario));
    let result = test_scenario::next_tx(&mut scenario, tester1);
    assert!(result.num_user_events() == 1);

    app::destroy_for_testing(admin);
    app::destroy_acl_for_testing(acl);
    test_scenario::end(scenario);
}

#[test]
public fun set_pool_admin() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let admin = app::create_for_testing(test_scenario::ctx(&mut scenario));
    let mut acl = app::create_acl_for_testing(test_scenario::ctx(&mut scenario));

    th::setup(test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);

    app::set_pool_admin(&admin, &mut acl, tester1, test_scenario::ctx(&mut scenario));
    let result = test_scenario::next_tx(&mut scenario, tester1);
    assert!(result.num_user_events() == 1);

    app::destroy_for_testing(admin);
    app::destroy_acl_for_testing(acl);
    test_scenario::end(scenario);
}

#[test]
public fun get_rewarder_admin() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let admin = app::create_for_testing(test_scenario::ctx(&mut scenario));
    let mut acl = app::create_acl_for_testing(test_scenario::ctx(&mut scenario));

    th::setup(test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);

    app::set_rewarder_admin(&admin, &mut acl, tester1, test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);
    assert!(app::get_rewarder_admin(&acl) == tester1);

    app::destroy_for_testing(admin);
    app::destroy_acl_for_testing(acl);
    test_scenario::end(scenario);
}

#[test]
public fun get_pool_admin() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let admin = app::create_for_testing(test_scenario::ctx(&mut scenario));
    let mut acl = app::create_acl_for_testing(test_scenario::ctx(&mut scenario));

    th::setup(test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);

    app::set_pool_admin(&admin, &mut acl, tester1, test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);
    assert!(app::get_pool_admin(&acl) == tester1);

    app::destroy_for_testing(admin);
    app::destroy_acl_for_testing(acl);
    test_scenario::end(scenario);
}

#[test]
public fun test_initial_admin_values() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let admin = app::create_for_testing(test_scenario::ctx(&mut scenario));
    let acl = app::create_acl_for_testing(test_scenario::ctx(&mut scenario));

    th::setup(test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);

    assert!(app::get_rewarder_admin(&acl) == tester1);
    assert!(app::get_pool_admin(&acl) == tester1);

    app::destroy_for_testing(admin);
    app::destroy_acl_for_testing(acl);
    test_scenario::end(scenario);
}

#[test]
public fun test_concurrent_admin_operations() {
    let tester1 = @0xAF;
    let tester2 = @0xBF;
    let mut scenario = test_scenario::begin(tester1);
    let admin = app::create_for_testing(test_scenario::ctx(&mut scenario));
    let mut acl = app::create_acl_for_testing(test_scenario::ctx(&mut scenario));

    th::setup(test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);

    app::set_rewarder_admin(&admin, &mut acl, tester1, test_scenario::ctx(&mut scenario));
    app::set_pool_admin(&admin, &mut acl, tester2, test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);

    assert!(app::get_rewarder_admin(&acl) == tester1);
    assert!(app::get_pool_admin(&acl) == tester2);

    app::set_rewarder_admin(&admin, &mut acl, tester2, test_scenario::ctx(&mut scenario));
    app::set_pool_admin(&admin, &mut acl, tester1, test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);

    assert!(app::get_rewarder_admin(&acl) == tester2);
    assert!(app::get_pool_admin(&acl) == tester1);

    app::destroy_for_testing(admin);
    app::destroy_acl_for_testing(acl);
    test_scenario::end(scenario);
}

#[test]
public fun test_event_emission() {
    let tester1 = @0xAF;
    let tester2 = @0xBF;
    let mut scenario = test_scenario::begin(tester1);
    let admin = app::create_for_testing(test_scenario::ctx(&mut scenario));
    let mut acl = app::create_acl_for_testing(test_scenario::ctx(&mut scenario));

    th::setup(test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);

    app::set_rewarder_admin(&admin, &mut acl, tester2, test_scenario::ctx(&mut scenario));
    let result1 = test_scenario::next_tx(&mut scenario, tester1);
    assert!(result1.num_user_events() == 1);

    app::set_pool_admin(&admin, &mut acl, tester2, test_scenario::ctx(&mut scenario));
    let result2 = test_scenario::next_tx(&mut scenario, tester1);
    assert!(result2.num_user_events() == 1);

    app::destroy_for_testing(admin);
    app::destroy_acl_for_testing(acl);
    test_scenario::end(scenario);
}

#[test]
public fun init_sets_defaults_and_shares_acl() {
    let publisher = @0xA1;
    let mut scenario = test_scenario::begin(publisher);

    app::call_init_for_test(test_scenario::ctx(&mut scenario));
    let _ = test_scenario::next_tx(&mut scenario, publisher);

    let acl = test_scenario::take_shared<app::Acl>(&scenario);

    assert!(app::get_rewarder_admin(&acl) == publisher);
    assert!(app::get_pool_admin(&acl) == publisher);

    app::destroy_acl_for_testing(acl);
    test_scenario::end(scenario);
}
