#[test_only]
module mmt_v3::coin_sort_test;

use mmt_v3::create_pool;
use mmt_v3::test_helper::{Self as th, USDC, create_pool_};
use mmt_v3::version;
use sui::sui::SUI;
use sui::test_scenario;

#[test]
public fun test_should_swap_types() {
    // SUI vs USDC
    let swap1 = create_pool::check_coin_order<SUI, USDC>();
    let swap2 = create_pool::check_coin_order<USDC, SUI>();
    assert!(swap1);
    assert!(swap1 != swap2);
}

#[test]
public fun test_create_pool_positive_order() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));
    create_pool_<SUI, USDC>(100, 583337266871351588, true, &version, &mut scenario);
    test_scenario::next_tx(&mut scenario, tester1);

    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = 81, location = mmt_v3::create_pool)]
public fun test_create_pool_negative_order() {
    let tester1 = @0xAF;
    let mut scenario = test_scenario::begin(tester1);
    let version = th::take_version(test_scenario::ctx(&mut scenario));
    create_pool_<USDC, SUI>(100, 583337266871351588, true, &version, &mut scenario);
    test_scenario::next_tx(&mut scenario, tester1);

    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}
