#[test_only]
module mmt_v3::math_u64_test;

use mmt_v3::math_u64;

const MAX_U64: u64 = 0xffffffffffffffff;

#[test]
fun test_wrapping_add() {
    assert!(math_u64::wrapping_add(10, 20) == 30);
    assert!(math_u64::wrapping_add(MAX_U64, 1) == 0);
    assert!(math_u64::wrapping_add(MAX_U64, MAX_U64) == 0xfffffffffffffffe);
    assert!(math_u64::wrapping_add(0, 0) == 0);
    assert!(math_u64::wrapping_add(MAX_U64, 0) == MAX_U64);
}

#[test]
fun test_overflowing_add() {
    let (sum, overflow) = math_u64::overflowing_add(10, 20);
    assert!(sum == 30 && overflow == false);

    let (sum, overflow) = math_u64::overflowing_add(MAX_U64, 1);
    assert!(sum == 0 && overflow == true);

    let (sum, overflow) = math_u64::overflowing_add(MAX_U64, MAX_U64);
    assert!(sum == 0xfffffffffffffffe && overflow == true);

    let (sum, overflow) = math_u64::overflowing_add(0, 0);
    assert!(sum == 0 && overflow == false);

    let (sum, overflow) = math_u64::overflowing_add(MAX_U64, 0);
    assert!(sum == MAX_U64 && overflow == false);
}

#[test]
fun test_wrapping_sub() {
    assert!(math_u64::wrapping_sub(20, 10) == 10);
    assert!(math_u64::wrapping_sub(10, 20) == 0xfffffffffffffff6);
    assert!(math_u64::wrapping_sub(0, 1) == MAX_U64);
    assert!(math_u64::wrapping_sub(MAX_U64, MAX_U64) == 0);
    assert!(math_u64::wrapping_sub(0, 0) == 0);
}

#[test]
fun test_overflowing_sub() {
    let (result, overflow) = math_u64::overflowing_sub(20, 10);
    assert!(result == 10 && overflow == false);

    let (result, overflow) = math_u64::overflowing_sub(10, 20);
    assert!(result == 0xfffffffffffffff6 && overflow == true);

    let (result, overflow) = math_u64::overflowing_sub(0, 1);
    assert!(result == MAX_U64 && overflow == true);

    let (result, overflow) = math_u64::overflowing_sub(MAX_U64, MAX_U64);
    assert!(result == 0 && overflow == false);

    let (result, overflow) = math_u64::overflowing_sub(0, 0);
    assert!(result == 0 && overflow == false);
}

#[test]
fun test_wrapping_mul() {
    assert!(math_u64::wrapping_mul(10, 10) == 100);
    assert!(math_u64::wrapping_mul(MAX_U64, 0) == 0);
    assert!(math_u64::wrapping_mul(0, MAX_U64) == 0);
    assert!(math_u64::wrapping_mul(MAX_U64, 1) == MAX_U64);
    assert!(math_u64::wrapping_mul(1, MAX_U64) == MAX_U64);
    assert!(math_u64::wrapping_mul(2, MAX_U64) == 0xfffffffffffffffe);
    assert!(math_u64::wrapping_mul(MAX_U64, 2) == 0xfffffffffffffffe);
}

#[test]
fun test_overflowing_mul() {
    let (result, overflow) = math_u64::overflowing_mul(10, 10);
    assert!(result == 100 && overflow == false);

    let (result, overflow) = math_u64::overflowing_mul(MAX_U64, 0);
    assert!(result == 0 && overflow == false);

    let (result, overflow) = math_u64::overflowing_mul(0, MAX_U64);
    assert!(result == 0 && overflow == false);

    let (result, overflow) = math_u64::overflowing_mul(MAX_U64, 1);
    assert!(result == MAX_U64 && overflow == false);

    let (result, overflow) = math_u64::overflowing_mul(1, MAX_U64);
    assert!(result == MAX_U64 && overflow == false);

    let (result, overflow) = math_u64::overflowing_mul(2, MAX_U64);
    assert!(result == 0xfffffffffffffffe && overflow == true);

    let (result, overflow) = math_u64::overflowing_mul(MAX_U64, 2);
    assert!(result == 0xfffffffffffffffe && overflow == true);
}

#[test]
fun test_carry_add() {
    let (sum, carry) = math_u64::carry_add(10, 20, 0);
    assert!(sum == 30 && carry == 0);

    let (sum, carry) = math_u64::carry_add(10, 20, 1);
    assert!(sum == 31 && carry == 0);

    let (sum, carry) = math_u64::carry_add(MAX_U64, 1, 0);
    assert!(sum == 0 && carry == 1);

    let (sum, carry) = math_u64::carry_add(MAX_U64, 0, 1);
    assert!(sum == 0 && carry == 1);

    let (sum, carry) = math_u64::carry_add(MAX_U64, MAX_U64, 0);
    assert!(sum == 0xfffffffffffffffe && carry == 1);

    let (sum, carry) = math_u64::carry_add(MAX_U64, MAX_U64, 1);
    assert!(sum == 0xffffffffffffffff && carry == 1);

    let (sum, carry) = math_u64::carry_add(0, 0, 0);
    assert!(sum == 0 && carry == 0);

    let (sum, carry) = math_u64::carry_add(0, 0, 1);
    assert!(sum == 1 && carry == 0);
}

#[test]
fun test_add_check() {
    assert!(math_u64::add_check(10, 20) == true);
    assert!(math_u64::add_check(MAX_U64, 0) == true);
    assert!(math_u64::add_check(0, MAX_U64) == true);
    assert!(math_u64::add_check(MAX_U64, 1) == false);
    assert!(math_u64::add_check(1, MAX_U64) == false);
    assert!(math_u64::add_check(MAX_U64, MAX_U64) == false);
    assert!(math_u64::add_check(0, 0) == true);
}

#[test]
#[expected_failure(abort_code = 0, location = mmt_v3::math_u64)]
fun test_carry_add_invalid_carry() {
    math_u64::carry_add(10, 20, 2);
}
