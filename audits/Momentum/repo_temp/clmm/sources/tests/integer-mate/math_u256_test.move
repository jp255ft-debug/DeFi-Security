#[test_only]
module mmt_v3::math_u256_test;

use mmt_v3::math_u256::{div_mod, shlw, shrw, checked_shlw, div_round, add_check, overflow_add};

const MAX_U256: u256 = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

#[test]
fun test_div_mod() {
    // Test basic division and modulo
    let (quotient, remainder) = div_mod(10, 3);
    assert!(quotient == 3);
    assert!(remainder == 1);

    let (quotient, remainder) = div_mod(15, 5);
    assert!(quotient == 3);
    assert!(remainder == 0);

    let (quotient, remainder) = div_mod(7, 10);
    assert!(quotient == 0);
    assert!(remainder == 7);

    // Test large numbers
    let large_num: u256 = 1000000000000000000000000000000000000;
    let divisor: u256 = 1000000000000000000;
    let (quotient, remainder) = div_mod(large_num, divisor);
    assert!(quotient == 1000000000000000000);
    assert!(remainder == 0);

    // Test edge cases
    let (quotient, remainder) = div_mod(0, 100);
    assert!(quotient == 0);
    assert!(remainder == 0);

    let (quotient, remainder) = div_mod(MAX_U256, 1);
    assert!(quotient == MAX_U256);
    assert!(remainder == 0);
}

#[test]
fun test_shlw() {
    // Test basic left shift by 64 bits
    let num: u256 = 1;
    let result = shlw(num);
    assert!(result == 18446744073709551616u256); // 2^64

    let num: u256 = 1000;
    let result = shlw(num);
    assert!(result == 18446744073709551616000u256); // 1000 * 2^64

    // Test with zero
    let result = shlw(0);
    assert!(result == 0);

    // Test large numbers
    let large_num: u256 = 1000000000000000000;
    let result = shlw(large_num);
    assert!(result == large_num << 64);
}

#[test]
fun test_shrw() {
    // Test basic right shift by 64 bits
    let num: u256 = 18446744073709551616u256; // 2^64
    let result = shrw(num);
    assert!(result == 1);

    let num: u256 = 18446744073709551616000u256; // 1000 * 2^64
    let result = shrw(num);
    assert!(result == 1000);

    // Test with zero
    let result = shrw(0);
    assert!(result == 0);

    // Test numbers smaller than 2^64
    let small_num: u256 = 1000;
    let result = shrw(small_num);
    assert!(result == 0);
}

#[test]
fun test_checked_shlw() {
    // Test successful left shift
    let num: u256 = 1;
    let (result, overflow) = checked_shlw(num);
    assert!(result == 18446744073709551616u256); // 2^64
    assert!(!overflow);

    let num: u256 = 1000;
    let (result, overflow) = checked_shlw(num);
    assert!(result == 18446744073709551616000u256); // 1000 * 2^64
    assert!(!overflow);

    // Test overflow case
    let num: u256 = 1u256 << 192; // This will overflow
    let (result, overflow) = checked_shlw(num);
    assert!(result == 0);
    assert!(overflow);

    let num: u256 = 1u256 << 193; // This will also overflow
    let (result, overflow) = checked_shlw(num);
    assert!(result == 0);
    assert!(overflow);

    // Test with zero
    let (result, overflow) = checked_shlw(0);
    assert!(result == 0);
    assert!(!overflow);
}

#[test]
fun test_div_round() {
    // Test rounding up
    let round_up = div_round(8, 3, true);
    assert!(round_up == 3);
    let round_up = div_round(10, 3, true);
    assert!(round_up == 4);

    // Test rounding down
    let round_down = div_round(8, 3, false);
    assert!(round_down == 2);
    let round_down = div_round(10, 3, false);
    assert!(round_down == 3);

    // Test exact division
    let result = div_round(15, 3, true);
    assert!(result == 5);
    let result = div_round(15, 3, false);
    assert!(result == 5);

    // Test edge cases
    let result = div_round(0, 100, true);
    assert!(result == 0);
    let result = div_round(0, 100, false);
    assert!(result == 0);

    let result = div_round(MAX_U256, 1, true);
    assert!(result == MAX_U256);
    let result = div_round(MAX_U256, 1, false);
    assert!(result == MAX_U256);
}

#[test]
#[expected_failure(abort_code = 200, location = mmt_v3::math_u256)]
fun test_div_round_div_by_zero() {
    div_round(8, 0, true);
}

#[test]
fun test_add_check() {
    // Test addition without overflow
    assert!(add_check(1000, 2000));
    assert!(add_check(0, MAX_U256));
    assert!(add_check(MAX_U256, 0));

    // Test addition with overflow
    assert!(!add_check(MAX_U256, 1));
    assert!(!add_check(1, MAX_U256));
    assert!(!add_check(MAX_U256, MAX_U256));

    // Test edge cases
    assert!(add_check(0, 0));
    assert!(add_check(MAX_U256 - 1, 1));
    assert!(!add_check(MAX_U256 - 1, 2));
}

#[test]
fun test_overflow_add() {
    // Test addition without overflow
    assert!(overflow_add(1000, 2000) == 3000);
    assert!(overflow_add(0, MAX_U256) == MAX_U256);
    assert!(overflow_add(MAX_U256, 0) == MAX_U256);

    // Test addition with overflow
    let result = overflow_add(MAX_U256, 1);
    assert!(result == 0); // Should wrap around to 0

    let result = overflow_add(MAX_U256, 100);
    assert!(result == 99); // Should wrap around

    let result = overflow_add(MAX_U256, MAX_U256);
    assert!(result == MAX_U256 - 1); // Should wrap around

    // Test edge cases
    assert!(overflow_add(0, 0) == 0);
    assert!(overflow_add(MAX_U256 - 1, 1) == MAX_U256);
}

#[test]
fun test_edge_cases() {
    // Test very large numbers
    let very_large: u256 = 1000000000000000000000000000000000000000000000000000000000000000000;
    let (quotient, remainder) = div_mod(very_large, 1000000000000000000);
    assert!(quotient == 1000000000000000000000000000000000000000000000000);
    assert!(remainder == 0);

    // Test maximum values
    let (quotient, remainder) = div_mod(MAX_U256, MAX_U256);
    assert!(quotient == 1);
    assert!(remainder == 0);

    // Test shift operations with large numbers
    let large_num: u256 = 1000000000000000000000000000000000000;
    let shifted_left = shlw(large_num);
    let shifted_right = shrw(shifted_left);
    assert!(shifted_right == large_num);
}

#[test]
fun test_comprehensive_operations() {
    // Test a combination of operations
    let num1: u256 = 1000000000000000000;
    let num2: u256 = 2000000000000000000;

    // Test div_mod
    let (quotient, remainder) = div_mod(num1, num2);
    assert!(quotient == 0);
    assert!(remainder == num1);

    // Test shift operations
    let shifted = shlw(num1);
    let unshifted = shrw(shifted);
    assert!(unshifted == num1);

    // Test checked shift
    let (result, overflow) = checked_shlw(num1);
    assert!(!overflow);
    assert!(result == shifted);

    // Test div_round
    let round_up = div_round(num1, num2, true);
    let round_down = div_round(num1, num2, false);
    assert!(round_up == 1);
    assert!(round_down == 0);

    // Test add operations
    assert!(add_check(num1, num2));
    assert!(overflow_add(num1, num2) == num1 + num2);
}
