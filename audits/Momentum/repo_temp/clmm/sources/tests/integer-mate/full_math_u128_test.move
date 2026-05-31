#[test_only]
module mmt_v3::full_math_u128_test;

use mmt_v3::full_math_u128::{
    Self,
    full_mul,
    max,
    min,
    mul_div_ceil,
    mul_div_floor,
    mul_div_round,
    mul_shl,
    mul_shr,
    overflowing_add,
    overflowing_sub,
    wrapping_add,
    wrapping_sub
};

const MAX_U128: u128 = 340282366920938463463374607431768211455;

#[test]
fun test_full_mul() {
    // Test basic multiplication
    assert!(full_mul(2, 3) == 6u256);
    assert!(full_mul(100, 200) == 20000u256);
    assert!(full_mul(0, 12345) == 0u256);
    assert!(full_mul(12345, 0) == 0u256);

    // Test large numbers
    let large_num1: u128 = 1000000000000000000;
    let large_num2: u128 = 2000000000000000000;
    let expected: u256 = 2000000000000000000000000000000000000;
    assert!(full_mul(large_num1, large_num2) == expected);

    // Test maximum values
    assert!(full_mul(MAX_U128, 1) == (MAX_U128 as u256));
    assert!(full_mul(1, MAX_U128) == (MAX_U128 as u256));
}

#[test]
fun test_max() {
    // Test basic max function
    assert!(max(5, 3) == 5);
    assert!(max(3, 5) == 5);
    assert!(max(10, 10) == 10);
    assert!(max(0, 1) == 1);
    assert!(max(1, 0) == 1);

    // Test large numbers
    assert!(max(MAX_U128, MAX_U128 - 1) == MAX_U128);
    assert!(max(MAX_U128 - 1, MAX_U128) == MAX_U128);
}

#[test]
fun test_min() {
    // Test basic min function
    assert!(min(5, 3) == 3);
    assert!(min(3, 5) == 3);
    assert!(min(10, 10) == 10);
    assert!(min(0, 1) == 0);
    assert!(min(1, 0) == 0);

    // Test large numbers
    assert!(min(MAX_U128, MAX_U128 - 1) == MAX_U128 - 1);
    assert!(min(MAX_U128 - 1, MAX_U128) == MAX_U128 - 1);
}

#[test]
fun test_mul_div_floor() {
    // Test basic division
    assert!(mul_div_floor(10, 2, 5) == 4);
    assert!(mul_div_floor(15, 3, 5) == 9);
    assert!(mul_div_floor(100, 200, 50) == 400);

    // Test with remainder (should truncate)
    assert!(mul_div_floor(10, 3, 4) == 7); // (10 * 3) / 4 = 30 / 4 = 7.5 -> 7
    assert!(mul_div_floor(7, 5, 3) == 11); // (7 * 5) / 3 = 35 / 3 = 11.66... -> 11

    // Test edge cases
    assert!(mul_div_floor(0, 100, 50) == 0);
    assert!(mul_div_floor(100, 0, 50) == 0);
    assert!(mul_div_floor(MAX_U128, 1, MAX_U128) == 1);
}

#[test]
fun test_mul_div_ceil() {
    // Test basic division with ceiling
    assert!(mul_div_ceil(10, 2, 5) == 4);
    assert!(mul_div_ceil(15, 3, 5) == 9);
    assert!(mul_div_ceil(100, 200, 50) == 400);

    // Test with remainder (should round up)
    assert!(mul_div_ceil(10, 3, 4) == 8); // (10 * 3) / 4 = 30 / 4 = 7.5 -> 8
    assert!(mul_div_ceil(7, 5, 3) == 12); // (7 * 5) / 3 = 35 / 3 = 11.66... -> 12

    // Test exact division
    assert!(mul_div_ceil(8, 2, 4) == 4); // (8 * 2) / 4 = 16 / 4 = 4 -> 4

    // Test edge cases
    assert!(mul_div_ceil(0, 100, 50) == 0);
    assert!(mul_div_ceil(100, 0, 50) == 0);
    assert!(mul_div_ceil(MAX_U128, 1, MAX_U128) == 1);
}

#[test]
fun test_mul_div_round() {
    // Test basic division with rounding
    assert!(mul_div_round(10, 2, 5) == 4);
    assert!(mul_div_round(15, 3, 5) == 9);
    assert!(mul_div_round(100, 200, 50) == 400);

    // Test rounding up
    assert!(mul_div_round(10, 3, 4) == 8); // (10 * 3) / 4 = 30 / 4 = 7.5 -> 8
    assert!(mul_div_round(7, 5, 3) == 12); // (7 * 5) / 3 = 35 / 3 = 11.66... -> 12

    // Test rounding down
    assert!(mul_div_round(10, 1, 4) == 3); // (10 * 1) / 4 = 10 / 4 = 2.5 -> 3
    assert!(mul_div_round(5, 3, 4) == 4); // (5 * 3) / 4 = 15 / 4 = 3.75 -> 4

    // Test exact division
    assert!(mul_div_round(8, 2, 4) == 4); // (8 * 2) / 4 = 16 / 4 = 4 -> 4

    // Test edge cases
    assert!(mul_div_round(0, 100, 50) == 0);
    assert!(mul_div_round(100, 0, 50) == 0);
    assert!(mul_div_round(MAX_U128, 1, MAX_U128) == 1);
}

#[test]
fun test_mul_shl() {
    // Test basic left shift
    assert!(mul_shl(2, 3, 1) == 12); // (2 * 3) << 1 = 6 << 1 = 12
    assert!(mul_shl(4, 5, 2) == 80); // (4 * 5) << 2 = 20 << 2 = 80
    assert!(mul_shl(10, 20, 3) == 1600); // (10 * 20) << 3 = 200 << 3 = 1600

    // Test with zero
    assert!(mul_shl(0, 100, 5) == 0);
    assert!(mul_shl(100, 0, 5) == 0);

    // Test large numbers
    let large_num: u128 = 1000000000000000000;
    assert!(mul_shl(large_num, 2, 1) == large_num * 4);
}

#[test]
fun test_mul_shr() {
    // Test basic right shift
    assert!(mul_shr(12, 2, 1) == 12); // (12 * 2) >> 1 = 24 >> 1 = 12
    assert!(mul_shr(4, 8, 2) == 8); // (4 * 8) >> 2 = 32 >> 2 = 8
    assert!(mul_shr(10, 20, 3) == 25); // (10 * 20) >> 3 = 200 >> 3 = 25

    // Test with zero
    assert!(mul_shr(0, 100, 5) == 0);
    assert!(mul_shr(100, 0, 5) == 0);

    // Test large numbers
    let large_num: u128 = 1000000000000000000;
    assert!(mul_shr(large_num, 2, 1) == large_num);
}

#[test]
fun test_overflowing_add() {
    // Test basic addition without overflow
    let (result, overflow) = overflowing_add(5, 3);
    assert!(result == 8);
    assert!(!overflow);

    let (result, overflow) = overflowing_add(0, 100);
    assert!(result == 100);
    assert!(!overflow);

    // Test addition with overflow
    let (result, overflow) = overflowing_add(MAX_U128, 1);
    assert!(result == 0);
    assert!(overflow);

    let (result, overflow) = overflowing_add(MAX_U128, MAX_U128);
    assert!(result == MAX_U128 - 1);
    assert!(overflow);

    // Test edge cases
    let (result, overflow) = overflowing_add(0, 0);
    assert!(result == 0);
    assert!(!overflow);
}

#[test]
fun test_overflowing_sub() {
    // Test basic subtraction without overflow
    let (result, overflow) = overflowing_sub(10, 3);
    assert!(result == 7);
    assert!(!overflow);

    let (result, overflow) = overflowing_sub(100, 0);
    assert!(result == 100);
    assert!(!overflow);

    let (result, overflow) = overflowing_sub(5, 5);
    assert!(result == 0);
    assert!(!overflow);

    // Test subtraction with overflow (underflow)
    let (result, overflow) = overflowing_sub(3, 10);
    assert!(result == MAX_U128 - 6);
    assert!(overflow);

    let (result, overflow) = overflowing_sub(0, 1);
    assert!(result == MAX_U128);
    assert!(overflow);

    // Test edge cases
    let (result, overflow) = overflowing_sub(0, 0);
    assert!(result == 0);
    assert!(!overflow);
}

#[test]
fun test_wrapping_add() {
    // Test basic addition without overflow
    assert!(wrapping_add(5, 3) == 8);
    assert!(wrapping_add(0, 100) == 100);

    // Test addition with overflow
    assert!(wrapping_add(MAX_U128, 1) == 0);
    assert!(wrapping_add(MAX_U128, MAX_U128) == MAX_U128 - 1);

    // Test edge cases
    assert!(wrapping_add(0, 0) == 0);
}

#[test]
fun test_wrapping_sub() {
    // Test basic subtraction without overflow
    assert!(wrapping_sub(10, 3) == 7);
    assert!(wrapping_sub(100, 0) == 100);
    assert!(wrapping_sub(5, 5) == 0);

    // Test subtraction with overflow (underflow)
    assert!(wrapping_sub(3, 10) == MAX_U128 - 6);
    assert!(wrapping_sub(0, 1) == MAX_U128);

    // Test edge cases
    assert!(wrapping_sub(0, 0) == 0);
}

#[test]
fun test_edge_cases() {
    // Test very large numbers
    let very_large: u128 = 100000000000000000000000000000000000;
    assert!(mul_div_floor(very_large, 2, 3) == (very_large * 2) / 3);
    assert!(mul_div_ceil(very_large, 2, 3) == ((very_large * 2) + 2) / 3);
    assert!(mul_div_round(very_large, 2, 3) == ((very_large * 2) + 1) / 3);

    // Test maximum values
    assert!(mul_div_floor(MAX_U128, 1, MAX_U128) == 1);
    assert!(mul_div_ceil(MAX_U128, 1, MAX_U128) == 1);
    assert!(mul_div_round(MAX_U128, 1, MAX_U128) == 1);
}

#[test]
fun test_comprehensive_mul_div() {
    // Test various combinations of mul_div functions
    let numerator: u128 = 1000;
    let multiplier: u128 = 2000;
    let denominator: u128 = 3000;

    let floor_result = mul_div_floor(numerator, multiplier, denominator);
    let ceil_result = mul_div_ceil(numerator, multiplier, denominator);
    let round_result = mul_div_round(numerator, multiplier, denominator);

    // Verify relationships between results
    assert!(floor_result <= round_result);
    assert!(round_result <= ceil_result);
    assert!(ceil_result <= floor_result + 1);

    // Test with different ratios
    let small_numerator: u128 = 1;
    let large_multiplier: u128 = 1000000;
    let small_denominator: u128 = 2;

    assert!(mul_div_floor(small_numerator, large_multiplier, small_denominator) == 500000);
    assert!(mul_div_ceil(small_numerator, large_multiplier, small_denominator) == 500000);
    assert!(mul_div_round(small_numerator, large_multiplier, small_denominator) == 500000);
}

#[test]
fun test_shift_operations() {
    // Test various shift amounts
    let base_value: u128 = 1000;
    let multiplier: u128 = 2000;

    // Test left shift
    assert!(mul_shl(base_value, multiplier, 0) == base_value * multiplier);
    assert!(mul_shl(base_value, multiplier, 1) == (base_value * multiplier) * 2);
    assert!(mul_shl(base_value, multiplier, 8) == (base_value * multiplier) * 256);

    // Test right shift
    assert!(mul_shr(base_value, multiplier, 0) == base_value * multiplier);
    assert!(mul_shr(base_value, multiplier, 1) == (base_value * multiplier) / 2);
    assert!(mul_shr(base_value, multiplier, 8) == (base_value * multiplier) / 256);

    // Test edge cases with large shifts
    let small_value: u128 = 1;
    let large_shift: u8 = 64;
    assert!(mul_shl(small_value, small_value, large_shift) == 1u128 << large_shift);
}
