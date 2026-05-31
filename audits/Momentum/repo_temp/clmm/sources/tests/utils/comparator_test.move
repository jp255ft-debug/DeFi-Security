#[test_only]
module mmt_v3::comparator_test;

use mmt_v3::comparator;
use sui::test_scenario;

#[test]
public fun test_compare_u8_vector_equal() {
    let tester = @0xAF;
    let scenario = test_scenario::begin(tester);

    let vec1 = vector[0x48, 0x65, 0x6C, 0x6C, 0x6F]; // "Hello"
    let vec2 = vector[0x48, 0x65, 0x6C, 0x6C, 0x6F]; // "Hello"

    let result = comparator::compare_u8_vector(vec1, vec2);

    assert!(comparator::is_equal(&result));
    assert!(!comparator::is_greater_than(&result));
    assert!(!comparator::is_smaller_than(&result));

    test_scenario::end(scenario);
}

#[test]
public fun test_compare_u8_vector_greater_than() {
    let tester = @0xAF;
    let scenario = test_scenario::begin(tester);

    let vec1 = vector[0x57, 0x6F, 0x72, 0x6C, 0x64]; // "World"
    let vec2 = vector[0x48, 0x65, 0x6C, 0x6C, 0x6F]; // "Hello"

    let result = comparator::compare_u8_vector(vec1, vec2);

    assert!(!comparator::is_equal(&result));
    assert!(comparator::is_greater_than(&result));
    assert!(!comparator::is_smaller_than(&result));

    test_scenario::end(scenario);
}

#[test]
public fun test_compare_u8_vector_smaller_than() {
    let tester = @0xAF;
    let scenario = test_scenario::begin(tester);

    let vec1 = vector[1, 2, 2];
    let vec2 = vector[1, 2, 3];

    let result = comparator::compare_u8_vector(vec1, vec2);

    assert!(!comparator::is_equal(&result));
    assert!(!comparator::is_greater_than(&result));
    assert!(comparator::is_smaller_than(&result));

    test_scenario::end(scenario);
}

#[test]
public fun test_compare_u8_vector_different_lengths() {
    let tester = @0xAF;
    let scenario = test_scenario::begin(tester);

    // Test shorter vector is smaller
    let vec1 = vector[1, 2];
    let vec2 = vector[1, 2, 3];

    let result = comparator::compare_u8_vector(vec1, vec2);
    assert!(comparator::is_smaller_than(&result));

    // Test longer vector is greater
    let vec3 = vector[1, 2, 3];
    let vec4 = vector[1, 2];

    let result2 = comparator::compare_u8_vector(vec3, vec4);
    assert!(comparator::is_greater_than(&result2));

    test_scenario::end(scenario);
}

#[test]
public fun test_compare_u8_vector_empty_vectors() {
    let tester = @0xAF;
    let scenario = test_scenario::begin(tester);

    let vec1 = vector::empty<u8>();
    let vec2 = vector::empty<u8>();

    let result = comparator::compare_u8_vector(vec1, vec2);
    assert!(comparator::is_equal(&result));

    test_scenario::end(scenario);
}

#[test]
public fun test_compare_u8_vector_large_values() {
    let tester = @0xAF;
    let scenario = test_scenario::begin(tester);

    let vec1 = vector[255, 128, 64];
    let vec2 = vector[255, 128, 65];

    let result = comparator::compare_u8_vector(vec1, vec2);
    assert!(comparator::is_smaller_than(&result));

    let vec3 = vector[255, 128, 65];
    let vec4 = vector[255, 128, 64];

    let result2 = comparator::compare_u8_vector(vec3, vec4);
    assert!(comparator::is_greater_than(&result2));

    test_scenario::end(scenario);
}

#[test]
public fun test_compare_u8_vector_same_prefix() {
    let tester = @0xAF;
    let scenario = test_scenario::begin(tester);

    let vec1 = vector[1, 2, 3, 4];
    let vec2 = vector[1, 2, 3, 5];

    let result = comparator::compare_u8_vector(vec1, vec2);
    assert!(comparator::is_smaller_than(&result));

    let vec3 = vector[1, 2, 3, 5];
    let vec4 = vector[1, 2, 3, 4];

    let result2 = comparator::compare_u8_vector(vec3, vec4);
    assert!(comparator::is_greater_than(&result2));

    test_scenario::end(scenario);
}

#[test]
public fun test_compare_strings() {
    let tester = @0xAF;
    let scenario = test_scenario::begin(tester);

    let str1 = b"abc";
    let str2 = b"abd";

    let result = comparator::compare(&str1, &str2);
    assert!(comparator::is_smaller_than(&result));

    let result2 = comparator::compare(&str2, &str1);
    assert!(comparator::is_greater_than(&result2));

    let result3 = comparator::compare(&str1, &str1);
    assert!(comparator::is_equal(&result3));

    test_scenario::end(scenario);
}

#[test]
public fun test_compare_addresses() {
    let tester = @0xAF;
    let scenario = test_scenario::begin(tester);

    let addr1 = @0x123;
    let addr2 = @0x456;

    let result = comparator::compare(&addr1, &addr2);

    let _is_equal = comparator::is_equal(&result);
    let _is_greater = comparator::is_greater_than(&result);
    let _is_smaller = comparator::is_smaller_than(&result);

    test_scenario::end(scenario);
}

#[test]
public fun test_compare_edge_cases() {
    let tester = @0xAF;
    let scenario = test_scenario::begin(tester);

    let vec1 = vector[255];
    let vec2 = vector[255, 0];

    let result = comparator::compare_u8_vector(vec1, vec2);
    assert!(comparator::is_smaller_than(&result));

    let vec3 = vector[0, 0];
    let vec4 = vector[0];

    let result2 = comparator::compare_u8_vector(vec3, vec4);
    assert!(comparator::is_greater_than(&result2));

    test_scenario::end(scenario);
}
