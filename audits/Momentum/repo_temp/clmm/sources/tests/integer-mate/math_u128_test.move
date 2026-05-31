#[test_only]
module mmt_v3::math_u128_test;

use mmt_v3::math_u128;

const MAX_U128: u128 = 0xffffffffffffffffffffffffffffffff;

#[test]
fun test_overflowing_add() {
    let (m, o) = math_u128::overflowing_add(10, 10);
    assert!(m == 20u128 && o == false, 0);

    let (m, o) = math_u128::overflowing_add(MAX_U128, 10);
    assert!(m == 9u128 && o == true, 0);
}

#[test]
fun test_full_mul() {
    let (lo, hi) = math_u128::full_mul(0, 10);
    assert!(hi == 0 && lo == 0, 0);

    let (lo, hi) = math_u128::full_mul(10, 10);
    assert!(hi == 0 && lo == 100, 0);

    let (lo, hi) = math_u128::full_mul(9999, 10);
    assert!(hi == 0 && lo == 99990, 0);

    let (lo, hi) = math_u128::full_mul(MAX_U128, 0);
    assert!(hi == 0 && lo == 0, 0);

    let (lo, hi) = math_u128::full_mul(MAX_U128, 1);
    assert!(hi == 0 && lo == MAX_U128, 0);

    let (lo, hi) = math_u128::full_mul(MAX_U128, 10);
    assert!(hi == 9 && lo == 0xfffffffffffffffffffffffffffffff6, 0);

    let (lo, hi) = math_u128::full_mul(10, MAX_U128);
    assert!(hi == 9 && lo == 0xfffffffffffffffffffffffffffffff6, 0);

    let (lo, hi) = math_u128::full_mul(MAX_U128, MAX_U128);
    assert!(hi == 0xfffffffffffffffffffffffffffffffe && lo == 1, 0);
}

#[test]
fun test_wrapping_mul() {
    assert!(math_u128::wrapping_mul(0, 10) == 0, 0);
    assert!(math_u128::wrapping_mul(10, 0) == 0, 0);
    assert!(math_u128::wrapping_mul(10, 10) == 100, 0);
    assert!(math_u128::wrapping_mul(99999, 10) == 10 * 99999, 0);
    assert!(math_u128::wrapping_mul(MAX_U128, 0) == 0, 0);
    assert!(math_u128::wrapping_mul(MAX_U128, 1) == MAX_U128, 0);
    assert!(math_u128::wrapping_mul(MAX_U128, 10) == 0xfffffffffffffffffffffffffffffff6, 0);
    assert!(math_u128::wrapping_mul(10, MAX_U128) == 0xfffffffffffffffffffffffffffffff6, 0);
    assert!(math_u128::wrapping_mul(MAX_U128, MAX_U128) == 1, 0);
}

#[test]
fun test_overflowing_mul() {
    let (r, o) = math_u128::overflowing_mul(0, 10);
    assert!(r == 0 && o == false, 0);

    let (r, o) = math_u128::overflowing_mul(10, 10);
    assert!(r == 100 && o == false, 0);

    let (r, o) = math_u128::overflowing_mul(MAX_U128, 10);
    assert!(r == 0xfffffffffffffffffffffffffffffff6 && o == true, 0);
}

#[test]
#[expected_failure(abort_code = 200, location = mmt_v3::math_u128)]
fun test_div_round_div_by_zero() {
    math_u128::checked_div_round(8, 0, true);
}

#[test]
fun test_wrapping_add() {
    assert!(math_u128::wrapping_add(10, 20) == 30, 0);
    assert!(math_u128::wrapping_add(MAX_U128, 1) == 0, 0);
    assert!(math_u128::wrapping_add(MAX_U128, MAX_U128) == 0xfffffffffffffffffffffffffffffffe, 0);
    assert!(math_u128::wrapping_add(0, 0) == 0, 0);
    assert!(math_u128::wrapping_add(1000, 2000) == 3000, 0);
}

#[test]
fun test_wrapping_sub() {
    assert!(math_u128::wrapping_sub(20, 10) == 10, 0);
    assert!(math_u128::wrapping_sub(10, 20) == MAX_U128 - 9, 0);
    assert!(math_u128::wrapping_sub(0, 1) == MAX_U128, 0);
    assert!(math_u128::wrapping_sub(MAX_U128, MAX_U128) == 0, 0);
    assert!(math_u128::wrapping_sub(100, 50) == 50, 0);
}

#[test]
fun test_overflowing_sub() {
    let (result, overflow) = math_u128::overflowing_sub(20, 10);
    assert!(result == 10 && overflow == false, 0);

    let (_, overflow) = math_u128::overflowing_sub(10, 20);
    assert!(overflow == true, 0);

    let (_, overflow) = math_u128::overflowing_sub(0, 1);
    assert!(overflow == true, 0);

    let (result, overflow) = math_u128::overflowing_sub(MAX_U128, MAX_U128);
    assert!(result == 0 && overflow == false, 0);
}

#[test]
fun test_hi_lo_functions() {
    let test_value: u128 = 0x1234567890abcdef1134567890abcdef;

    assert!(math_u128::hi(test_value) == 0x1234567890abcdef, 0);

    assert!(math_u128::lo(test_value) == 0x1134567890abcdef, 0);

    assert!(math_u128::hi_u128(test_value) == 0x1234567890abcdef, 0);

    assert!(math_u128::lo_u128(test_value) == 0x1134567890abcdef, 0);

    let reconstructed = math_u128::from_lo_hi(0x1134567890abcdef, 0x1234567890abcdef);
    assert!(reconstructed == test_value, 0);
}

#[test]
fun test_checked_div_round() {
    assert!(math_u128::checked_div_round(10, 2, false) == 5, 0);
    assert!(math_u128::checked_div_round(10, 3, false) == 3, 0);

    assert!(math_u128::checked_div_round(10, 2, true) == 5, 0);
    assert!(math_u128::checked_div_round(10, 3, true) == 4, 0);
    assert!(math_u128::checked_div_round(11, 3, true) == 4, 0);

    assert!(math_u128::checked_div_round(0, 5, false) == 0, 0);
    assert!(math_u128::checked_div_round(0, 5, true) == 0, 0);
    assert!(math_u128::checked_div_round(MAX_U128, 1, false) == MAX_U128, 0);
    assert!(math_u128::checked_div_round(MAX_U128, 1, true) == MAX_U128, 0);
}

#[test]
fun test_max_min_functions() {
    assert!(math_u128::max(10, 20) == 20, 0);
    assert!(math_u128::max(20, 10) == 20, 0);
    assert!(math_u128::max(10, 10) == 10, 0);
    assert!(math_u128::max(0, MAX_U128) == MAX_U128, 0);
    assert!(math_u128::max(MAX_U128, 0) == MAX_U128, 0);

    assert!(math_u128::min(10, 20) == 10, 0);
    assert!(math_u128::min(20, 10) == 10, 0);
    assert!(math_u128::min(10, 10) == 10, 0);
    assert!(math_u128::min(0, MAX_U128) == 0, 0);
    assert!(math_u128::min(MAX_U128, 0) == 0, 0);
}

#[test]
fun test_add_check() {
    assert!(math_u128::add_check(10, 20) == true, 0);
    assert!(math_u128::add_check(0, MAX_U128) == true, 0);
    assert!(math_u128::add_check(MAX_U128, 0) == true, 0);
    assert!(math_u128::add_check(1000, 2000) == true, 0);

    assert!(math_u128::add_check(MAX_U128, 1) == false, 0);
    assert!(math_u128::add_check(1, MAX_U128) == false, 0);
    assert!(math_u128::add_check(MAX_U128, MAX_U128) == false, 0);
    assert!(math_u128::add_check(MAX_U128 - 1, 2) == false, 0);
}

#[test]
fun test_edge_cases() {
    assert!(math_u128::wrapping_add(0, 0) == 0, 0);
    assert!(math_u128::wrapping_sub(0, 0) == 0, 0);
    assert!(math_u128::wrapping_mul(0, 0) == 0, 0);
    assert!(math_u128::wrapping_mul(0, MAX_U128) == 0, 0);
    assert!(math_u128::wrapping_mul(MAX_U128, 0) == 0, 0);

    assert!(math_u128::wrapping_add(1, 1) == 2, 0);
    assert!(math_u128::wrapping_sub(1, 1) == 0, 0);
    assert!(math_u128::wrapping_mul(1, 1) == 1, 0);
    assert!(math_u128::wrapping_mul(1, MAX_U128) == MAX_U128, 0);
    assert!(math_u128::wrapping_mul(MAX_U128, 1) == MAX_U128, 0);

    assert!(math_u128::hi(0) == 0, 0);
    assert!(math_u128::lo(0) == 0, 0);
    assert!(math_u128::hi_u128(0) == 0, 0);
    assert!(math_u128::lo_u128(0) == 0, 0);

    assert!(math_u128::from_lo_hi(0, 0) == 0, 0);
}

#[test]
fun test_large_numbers() {
    let large_num1: u128 = 0x80000000000000000000000000000000; // 2^127
    let large_num2: u128 = 0x40000000000000000000000000000000; // 2^126

    let (_, overflow) = math_u128::overflowing_add(large_num1, large_num2);
    assert!(overflow == false, 0);

    let (_, hi) = math_u128::full_mul(large_num1, large_num2);
    assert!(hi > 0, 0);

    assert!(math_u128::hi(large_num1) == 0x8000000000000000, 0);
    assert!(math_u128::lo(large_num1) == 0, 0);
}
