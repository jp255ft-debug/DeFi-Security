#[test_only]
module mmt_v3::version_tests;

use mmt_v3::current_version::{current_major_version, current_minor_version};
use mmt_v3::version::{Self, Version};
use sui::test_scenario;

#[test]
public fun test_is_supported_major_version() {
    let tester = @0xAF;
    let mut scenario = test_scenario::begin(tester);
    let (version, version_cap) = version::init_with_cap(test_scenario::ctx(&mut scenario));

    assert!(version::is_supported_major_version(&version));

    version::destroy_version_for_testing(version);
    version::destroy_version_cap_for_testing(version_cap);
    test_scenario::end(scenario);
}

#[test]
public fun test_is_supported_major_version_fail() {
    let tester = @0xAF;
    let mut scenario = test_scenario::begin(tester);
    let (mut version, version_cap) = version::init_with_cap(test_scenario::ctx(&mut scenario));

    version::upgrade_major(&mut version, &version_cap);

    assert!(!version::is_supported_major_version(&version));

    version::destroy_version_for_testing(version);
    version::destroy_version_cap_for_testing(version_cap);
    test_scenario::end(scenario);
}

#[test]
public fun test_is_supported_minor_version() {
    let tester = @0xAF;
    let mut scenario = test_scenario::begin(tester);
    let (version, version_cap) = version::init_with_cap(test_scenario::ctx(&mut scenario));

    assert!(version::is_supported_minor_version(&version));

    version::destroy_version_for_testing(version);
    version::destroy_version_cap_for_testing(version_cap);
    test_scenario::end(scenario);
}

#[test]
public fun test_upgrade_major_success() {
    let tester = @0xAF;
    let mut scenario = test_scenario::begin(tester);
    let (mut version, version_cap) = version::init_with_cap(test_scenario::ctx(&mut scenario));

    let current_major = version::value_major(&version);
    let new_major = current_major + 1;
    version::upgrade_major(&mut version, &version_cap);

    assert!(version::value_major(&version) == new_major);

    version::destroy_version_for_testing(version);
    version::destroy_version_cap_for_testing(version_cap);
    test_scenario::end(scenario);
}

#[test]
public fun test_upgrade_minor_success() {
    let tester = @0xAF;
    let mut scenario = test_scenario::begin(tester);
    let (mut version, version_cap) = version::init_with_cap(test_scenario::ctx(&mut scenario));

    let current_minor = version::value_minor(&version);

    let new_minor = current_minor + 1;
    version::upgrade_minor(&mut version, new_minor, &version_cap);

    assert!(version::value_minor(&version) == new_minor);

    version::destroy_version_for_testing(version);
    version::destroy_version_cap_for_testing(version_cap);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = 78, location = mmt_v3::version)]
public fun test_upgrade_minor_failure_same_version() {
    let tester = @0xAF;
    let mut scenario = test_scenario::begin(tester);
    let (mut version, version_cap) = version::init_with_cap(test_scenario::ctx(&mut scenario));

    let current_minor = version::value_minor(&version);
    version::upgrade_minor(&mut version, current_minor, &version_cap);

    version::destroy_version_for_testing(version);
    version::destroy_version_cap_for_testing(version_cap);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = 78, location = mmt_v3::version)]
public fun test_upgrade_minor_failure_lower_version() {
    let tester = @0xAF;
    let mut scenario = test_scenario::begin(tester);
    let (mut version, version_cap) = version::init_with_cap(test_scenario::ctx(&mut scenario));

    let current_minor = version::value_minor(&version);
    version::upgrade_minor(&mut version, current_minor - 1, &version_cap);

    version::destroy_version_for_testing(version);
    version::destroy_version_cap_for_testing(version_cap);
    test_scenario::end(scenario);
}

#[test]
public fun test_set_version_success() {
    let tester = @0xAF;
    let mut scenario = test_scenario::begin(tester);
    let (mut version, version_cap) = version::init_with_cap(test_scenario::ctx(&mut scenario));

    let new_major = current_major_version() + 1;
    let new_minor = current_minor_version() + 1;

    version::set_version(&mut version, &version_cap, new_major, new_minor);

    assert!(version::value_major(&version) == new_major);
    assert!(version::value_minor(&version) == new_minor);

    version::destroy_version_for_testing(version);
    version::destroy_version_cap_for_testing(version_cap);
    test_scenario::end(scenario);
}

#[test]
public fun test_set_version_success_new_major_with_zero_minor() {
    let tester = @0xAF;
    let mut scenario = test_scenario::begin(tester);
    let (mut version, version_cap) = version::init_with_cap(test_scenario::ctx(&mut scenario));

    let new_major = current_major_version() + 1;
    let new_minor = 0;

    version::set_version(&mut version, &version_cap, new_major, new_minor);

    assert!(version::value_major(&version) == new_major);
    assert!(version::value_minor(&version) == new_minor);

    version::destroy_version_for_testing(version);
    version::destroy_version_cap_for_testing(version_cap);
    test_scenario::end(scenario);
}

#[test]
public fun test_set_version_success_same_major() {
    let tester = @0xAF;
    let mut scenario = test_scenario::begin(tester);
    let (mut version, version_cap) = version::init_with_cap(test_scenario::ctx(&mut scenario));

    let new_major = current_major_version();
    let new_minor = current_minor_version() + 1;

    version::set_version(&mut version, &version_cap, new_major, new_minor);

    assert!(version::value_major(&version) == new_major);
    assert!(version::value_minor(&version) == new_minor);

    version::destroy_version_for_testing(version);
    version::destroy_version_cap_for_testing(version_cap);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = 79, location = mmt_v3::version)]
public fun test_set_version_failure_lower_major() {
    let tester = @0xAF;
    let mut scenario = test_scenario::begin(tester);
    let (mut version, version_cap) = version::init_with_cap(test_scenario::ctx(&mut scenario));

    let new_major = current_major_version() - 1;
    let new_minor = current_minor_version() + 1;

    version::set_version(&mut version, &version_cap, new_major, new_minor);

    version::destroy_version_for_testing(version);
    version::destroy_version_cap_for_testing(version_cap);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = 78, location = mmt_v3::version)]
public fun test_set_version_failure_lower_minor_same_major() {
    let tester = @0xAF;
    let mut scenario = test_scenario::begin(tester);
    let (mut version, version_cap) = version::init_with_cap(test_scenario::ctx(&mut scenario));

    let new_major = current_major_version();
    let new_minor = current_minor_version() - 1;

    version::set_version(&mut version, &version_cap, new_major, new_minor);

    version::destroy_version_for_testing(version);
    version::destroy_version_cap_for_testing(version_cap);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = 78, location = mmt_v3::version)]
public fun test_set_version_failure_same_minor() {
    let tester = @0xAF;
    let mut scenario = test_scenario::begin(tester);
    let (mut version, version_cap) = version::init_with_cap(test_scenario::ctx(&mut scenario));

    let new_major = current_major_version();
    let new_minor = current_minor_version();

    version::set_version(&mut version, &version_cap, new_major, new_minor);

    version::destroy_version_for_testing(version);
    version::destroy_version_cap_for_testing(version_cap);
    test_scenario::end(scenario);
}

#[test]
public fun test_version_edge_cases() {
    let tester = @0xAF;
    let mut scenario = test_scenario::begin(tester);
    let (mut version, version_cap) = version::init_with_cap(test_scenario::ctx(&mut scenario));

    let current_minor = version::value_minor(&version);
    version::upgrade_minor(&mut version, current_minor + 1, &version_cap);
    assert!(version::value_minor(&version) == current_minor + 1);

    // Test edge case: upgrade major multiple times
    version::upgrade_major(&mut version, &version_cap);
    assert!(version::value_major(&version) == current_major_version() + 1);

    version::destroy_version_for_testing(version);
    version::destroy_version_cap_for_testing(version_cap);
    test_scenario::end(scenario);
}

#[test]
public fun test_version_compatibility() {
    let tester = @0xAF;
    let mut scenario = test_scenario::begin(tester);
    let version = version::init_(test_scenario::ctx(&mut scenario));

    assert!(version::is_supported_major_version(&version));
    assert!(version::is_supported_minor_version(&version));

    let (mut test_version, version_cap) = version::init_with_cap(test_scenario::ctx(&mut scenario));

    version::set_version(
        &mut test_version,
        &version_cap,
        current_major_version(),
        current_minor_version() + 5,
    );
    assert!(version::is_supported_major_version(&test_version));
    assert!(!version::is_supported_minor_version(&test_version));

    version::destroy_version_for_testing(version);
    version::destroy_version_for_testing(test_version);
    version::destroy_version_cap_for_testing(version_cap);
    test_scenario::end(scenario);
}

#[test]
public fun test_version_init() {
    let tester = @0xAF;
    let mut scenario = test_scenario::begin(tester);
    let (version, version_cap) = version::init_with_cap(test_scenario::ctx(&mut scenario));

    let major = version::value_major(&version);
    let minor = version::value_minor(&version);

    assert!(major == current_major_version());
    assert!(minor == current_minor_version());

    assert!(major >= 0);
    assert!(minor >= 0);

    version::destroy_version_for_testing(version);
    version::destroy_version_cap_for_testing(version_cap);
    test_scenario::end(scenario);
}

#[test]
public fun test_assert_supported_version() {
    let tester = @0xAF;
    let mut scenario = test_scenario::begin(tester);
    let version = version::init_(test_scenario::ctx(&mut scenario));

    version::assert_supported_version(&version);

    version::destroy_version_for_testing(version);
    test_scenario::end(scenario);
}

#[test]
#[expected_failure(abort_code = 69, location = mmt_v3::version)]
public fun test_assert_supported_version_fail() {
    let tester = @0xAF;
    let mut scenario = test_scenario::begin(tester);
    let (mut version, version_cap) = version::init_with_cap(test_scenario::ctx(&mut scenario));

    version::set_version(&mut version, &version_cap, current_major_version() + 10, 0);

    version::assert_supported_version(&version);

    version::destroy_version_for_testing(version);
    version::destroy_version_cap_for_testing(version_cap);
    test_scenario::end(scenario);
}

#[test]
public fun init_sets_defaults_version() {
    let tester = @0xAF;
    let mut scenario = test_scenario::begin(tester);

    version::call_init_for_test(test_scenario::ctx(&mut scenario));

    test_scenario::next_tx(&mut scenario, tester);
    let version = test_scenario::take_shared<Version>(&scenario);
    let init_major = version::value_major(&version);
    let init_minor = version::value_minor(&version);

    assert!(init_major == current_major_version());
    assert!(init_minor == current_minor_version());

    test_scenario::return_shared(version);
    test_scenario::end(scenario);
}
