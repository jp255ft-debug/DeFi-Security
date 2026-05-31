#[test_only]
module mmt_v3::global_config_test;

use mmt_v3::app;
use mmt_v3::global_config;
use mmt_v3::test_helper as th;
use sui::test_scenario;

#[test]
#[expected_failure(abort_code = 6, location = mmt_v3::global_config)]
public fun enable_fee_rate_nagetive_10000() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);

    th::setup(test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);

    let mut config = th::take_config(&mut scenario);
    let admin = app::create_for_testing(test_scenario::ctx(&mut scenario));
    global_config::enable_fee_rate(
        &admin,
        &mut config,
        2000,
        10000,
        test_scenario::ctx(&mut scenario),
    );

    let tx_result = test_scenario::next_tx(&mut scenario, tester1);
    assert!(tx_result.num_user_events() == 1);

    app::destroy_for_testing(admin);
    th::return_config(config);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = 6, location = mmt_v3::global_config)]
public fun enable_fee_rate_nagetive_0() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);

    th::setup(test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);

    let mut config = th::take_config(&mut scenario);
    let admin = app::create_for_testing(test_scenario::ctx(&mut scenario));
    global_config::enable_fee_rate(&admin, &mut config, 2000, 0, test_scenario::ctx(&mut scenario));

    let tx_result = test_scenario::next_tx(&mut scenario, tester1);
    assert!(tx_result.num_user_events() == 1);

    app::destroy_for_testing(admin);
    th::return_config(config);
    test_scenario::end(scenario);
}

#[test]
public fun test_enable_fee_rate_success() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);

    th::setup(test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);

    let mut config = th::take_config(&mut scenario);
    let admin = app::create_for_testing(test_scenario::ctx(&mut scenario));

    global_config::enable_fee_rate(
        &admin,
        &mut config,
        20000,
        400,
        test_scenario::ctx(&mut scenario),
    );
    let tx_result = test_scenario::next_tx(&mut scenario, tester1);
    assert!(tx_result.num_user_events() == 1);

    assert!(global_config::contains_fee_rate(&config, 20000));
    assert!(global_config::get_tick_spacing(&config, 20000) == 400);

    app::destroy_for_testing(admin);
    th::return_config(config);
    test_scenario::end(scenario);
}

#[test]
public fun test_initial_fee_rates() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);

    th::setup(test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);

    let config = th::take_config(&mut scenario);

    assert!(global_config::contains_fee_rate(&config, 100));
    assert!(global_config::contains_fee_rate(&config, 500));
    assert!(global_config::contains_fee_rate(&config, 3000));
    assert!(global_config::contains_fee_rate(&config, 10000));

    assert!(global_config::get_tick_spacing(&config, 100) == 2);
    assert!(global_config::get_tick_spacing(&config, 500) == 10);
    assert!(global_config::get_tick_spacing(&config, 3000) == 60);
    assert!(global_config::get_tick_spacing(&config, 10000) == 200);

    th::return_config(config);
    test_scenario::end(scenario);
}

#[test]
public fun test_multiple_fee_rates() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);

    th::setup(test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);

    let mut config = th::take_config(&mut scenario);
    let admin = app::create_for_testing(test_scenario::ctx(&mut scenario));

    global_config::enable_fee_rate(
        &admin,
        &mut config,
        1500,
        30,
        test_scenario::ctx(&mut scenario),
    );
    test_scenario::next_tx(&mut scenario, tester1);

    global_config::enable_fee_rate(
        &admin,
        &mut config,
        2500,
        50,
        test_scenario::ctx(&mut scenario),
    );
    test_scenario::next_tx(&mut scenario, tester1);

    assert!(global_config::contains_fee_rate(&config, 1500));
    assert!(global_config::contains_fee_rate(&config, 2500));

    assert!(global_config::get_tick_spacing(&config, 1500) == 30);
    assert!(global_config::get_tick_spacing(&config, 2500) == 50);

    app::destroy_for_testing(admin);
    th::return_config(config);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = 2, location = mmt_v3::global_config)]
public fun test_enable_fee_rate_already_exists() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);

    th::setup(test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);

    let mut config = th::take_config(&mut scenario);
    let admin = app::create_for_testing(test_scenario::ctx(&mut scenario));

    global_config::enable_fee_rate(&admin, &mut config, 100, 5, test_scenario::ctx(&mut scenario));

    app::destroy_for_testing(admin);
    th::return_config(config);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = 1, location = mmt_v3::global_config)]
public fun test_enable_fee_rate_too_high() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);

    th::setup(test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);

    let mut config = th::take_config(&mut scenario);
    let admin = app::create_for_testing(test_scenario::ctx(&mut scenario));

    global_config::enable_fee_rate(
        &admin,
        &mut config,
        1000000,
        5000,
        test_scenario::ctx(&mut scenario),
    );

    app::destroy_for_testing(admin);
    th::return_config(config);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = 6, location = mmt_v3::global_config)]
public fun test_enable_fee_rate_tick_spacing_too_high() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);

    th::setup(test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);

    let mut config = th::take_config(&mut scenario);
    let admin = app::create_for_testing(test_scenario::ctx(&mut scenario));

    global_config::enable_fee_rate(
        &admin,
        &mut config,
        2000,
        10000,
        test_scenario::ctx(&mut scenario),
    );

    app::destroy_for_testing(admin);
    th::return_config(config);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = 29, location = mmt_v3::global_config)]
public fun test_get_tick_spacing_invalid_fee_rate() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);

    th::setup(test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);

    let config = th::take_config(&mut scenario);

    global_config::get_tick_spacing(&config, 9999);

    th::return_config(config);
    test_scenario::end(scenario);
}

#[test]
public fun test_boundary_fee_rates() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);

    th::setup(test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);

    let mut config = th::take_config(&mut scenario);
    let admin = app::create_for_testing(test_scenario::ctx(&mut scenario));

    global_config::enable_fee_rate(
        &admin,
        &mut config,
        999999,
        1,
        test_scenario::ctx(&mut scenario),
    );
    test_scenario::next_tx(&mut scenario, tester1);

    global_config::enable_fee_rate(&admin, &mut config, 1, 9999, test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);

    assert!(global_config::contains_fee_rate(&config, 999999));
    assert!(global_config::contains_fee_rate(&config, 1));
    assert!(global_config::get_tick_spacing(&config, 999999) == 1);
    assert!(global_config::get_tick_spacing(&config, 1) == 9999);

    app::destroy_for_testing(admin);
    th::return_config(config);
    test_scenario::end(scenario);
}

#[test]
public fun test_event_emission() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);

    th::setup(test_scenario::ctx(&mut scenario));
    test_scenario::next_tx(&mut scenario, tester1);

    let mut config = th::take_config(&mut scenario);
    let admin = app::create_for_testing(test_scenario::ctx(&mut scenario));

    global_config::enable_fee_rate(
        &admin,
        &mut config,
        20000,
        400,
        test_scenario::ctx(&mut scenario),
    );
    let tx_result = test_scenario::next_tx(&mut scenario, tester1);
    assert!(tx_result.num_user_events() == 1);

    app::destroy_for_testing(admin);
    th::return_config(config);
    test_scenario::end(scenario);
}

#[test]
public fun init_sets_defaults() {
    let tester = @0xAF;
    let mut scenario = test_scenario::begin(tester);

    global_config::call_init_for_test(test_scenario::ctx(&mut scenario));

    test_scenario::next_tx(&mut scenario, tester);

    let config = th::take_config(&mut scenario);
    assert!(global_config::contains_fee_rate(&config, 100));
    assert!(global_config::contains_fee_rate(&config, 500));
    assert!(global_config::contains_fee_rate(&config, 3000));
    assert!(global_config::contains_fee_rate(&config, 10000));

    th::return_config(config);
    test_scenario::end(scenario);
}
