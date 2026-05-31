#[test_only]
module mmt_v3::i64_test;

use mmt_v3::i64::{
    Self,
    as_u64,
    from,
    neg_from,
    from_u64,
    abs,
    add,
    sub,
    mul,
    div,
    shl,
    shr,
    sign,
    cmp,
    zero,
    and,
    or,
    eq,
    is_neg,
    gt,
    lt,
    mod,
    wrapping_add,
    wrapping_sub,
    gte,
    lte
};

const MIN_AS_U64: u64 = 1 << 63;
const MAX_AS_U64: u64 = 0x7fffffffffffffff;
const LT: u8 = 0;
const EQ: u8 = 1;
const GT: u8 = 2;

#[test]
fun test_from_ok() {
    assert!(from(0) == zero(), 0);
    assert!(from(10) == from(10), 1);
}

#[test]
#[expected_failure]
fun test_from_overflow() {
    from(MIN_AS_U64);
    from(0xffffffffffffffff);
}

#[test]
fun test_neg_from() {
    assert!(eq(neg_from(0), from(0)), 0);
    assert!(eq(neg_from(1), from_u64(0xffffffffffffffff)), 1);
    assert!(eq(neg_from(0x7fffffffffffffff), from_u64(0x8000000000000001)), 2);
    assert!(eq(neg_from(MIN_AS_U64), from_u64(MIN_AS_U64)), 2);
}

#[test]
#[expected_failure]
fun test_neg_from_overflow() {
    neg_from(0x8000000000000001);
}

#[test]
fun test_abs() {
    assert!(abs(from(10)) == from(10), 0);
    assert!(abs(neg_from(10)) == from(10), 1);
    assert!(abs(neg_from(0)) == from(0), 2);
    assert!(abs(neg_from(0x7fffffffffffffff)) == from(0x7fffffffffffffff), 3);
}

#[test]
#[expected_failure]
fun test_abs_overflow_neg() {
    abs(neg_from(MIN_AS_U64));
}

#[test]
#[expected_failure]
fun test_abs_overflow() {
    abs(neg_from(1 << 63));
}

#[test]
fun test_wrapping_add() {
    assert!(as_u64(wrapping_add(from(0), from(1))) == 1, 0);
    assert!(as_u64(wrapping_add(from(1), from(0))) == 1, 0);
    assert!(as_u64(wrapping_add(from(10000), from(99999))) == 109999, 0);
    assert!(as_u64(wrapping_add(from(99999), from(10000))) == 109999, 0);
    assert!(as_u64(wrapping_add(from(MAX_AS_U64 - 1), from(1))) == MAX_AS_U64, 0);
    assert!(as_u64(wrapping_add(from(0), from(0))) == 0, 0);

    assert!(as_u64(wrapping_add(neg_from(0), neg_from(0))) == 0, 1);
    assert!(as_u64(wrapping_add(neg_from(1), neg_from(0))) == 0xffffffffffffffff, 1);
    assert!(as_u64(wrapping_add(neg_from(0), neg_from(1))) == 0xffffffffffffffff, 1);
    assert!(as_u64(wrapping_add(neg_from(10000), neg_from(99999))) == 0xfffffffffffe5251, 1);
    assert!(as_u64(wrapping_add(neg_from(99999), neg_from(10000))) == 0xfffffffffffe5251, 1);
    assert!(as_u64(wrapping_add(neg_from(MIN_AS_U64 - 1), neg_from(1))) == MIN_AS_U64, 1);

    assert!(as_u64(wrapping_add(from(0), neg_from(0))) == 0, 2);
    assert!(as_u64(wrapping_add(neg_from(0), from(0))) == 0, 2);
    assert!(as_u64(wrapping_add(neg_from(1), from(1))) == 0, 2);
    assert!(as_u64(wrapping_add(from(1), neg_from(1))) == 0, 2);
    assert!(as_u64(wrapping_add(from(10000), neg_from(99999))) == 0xfffffffffffea071, 2);
    assert!(as_u64(wrapping_add(from(99999), neg_from(10000))) == 89999, 2);
    assert!(as_u64(wrapping_add(neg_from(MIN_AS_U64), from(1))) == 0x8000000000000001, 2);
    assert!(as_u64(wrapping_add(from(MAX_AS_U64), neg_from(1))) == MAX_AS_U64 - 1, 2);

    assert!(as_u64(wrapping_add(from(MAX_AS_U64), from(1))) == MIN_AS_U64, 2);
}

#[test]
fun test_add() {
    assert!(as_u64(add(from(0), from(0))) == 0, 0);
    assert!(as_u64(add(from(0), from(1))) == 1, 0);
    assert!(as_u64(add(from(1), from(0))) == 1, 0);
    assert!(as_u64(add(from(10000), from(99999))) == 109999, 0);
    assert!(as_u64(add(from(99999), from(10000))) == 109999, 0);
    assert!(as_u64(add(from(MAX_AS_U64 - 1), from(1))) == MAX_AS_U64, 0);

    assert!(as_u64(add(neg_from(0), neg_from(0))) == 0, 1);
    assert!(as_u64(add(neg_from(1), neg_from(0))) == 0xffffffffffffffff, 1);
    assert!(as_u64(add(neg_from(0), neg_from(1))) == 0xffffffffffffffff, 1);
    assert!(as_u64(add(neg_from(10000), neg_from(99999))) == 0xfffffffffffe5251, 1);
    assert!(as_u64(add(neg_from(99999), neg_from(10000))) == 0xfffffffffffe5251, 1);
    assert!(as_u64(add(neg_from(MIN_AS_U64 - 1), neg_from(1))) == MIN_AS_U64, 1);

    assert!(as_u64(add(from(0), neg_from(0))) == 0, 2);
    assert!(as_u64(add(neg_from(0), from(0))) == 0, 2);
    assert!(as_u64(add(neg_from(1), from(1))) == 0, 2);
    assert!(as_u64(add(from(1), neg_from(1))) == 0, 2);
    assert!(as_u64(add(from(99999), neg_from(10000))) == 89999, 2);
    assert!(as_u64(add(neg_from(MIN_AS_U64), from(1))) == 0x8000000000000001, 2);
    assert!(as_u64(add(from(MAX_AS_U64), neg_from(1))) == MAX_AS_U64 - 1, 2);
}

#[test]
#[expected_failure]
fun test_add_overflow() {
    add(from(MAX_AS_U64), from(1));
}

#[test]
#[expected_failure]
fun test_add_underflow() {
    add(neg_from(MIN_AS_U64), neg_from(1));
}

#[test]
fun test_wrapping_sub() {
    assert!(as_u64(wrapping_sub(from(0), from(0))) == 0, 0);
    assert!(as_u64(wrapping_sub(from(1), from(0))) == 1, 0);
    assert!(as_u64(wrapping_sub(from(0), from(1))) == as_u64(neg_from(1)), 0);
    assert!(as_u64(wrapping_sub(from(1), from(1))) == as_u64(neg_from(0)), 0);
    assert!(as_u64(wrapping_sub(from(1), neg_from(1))) == as_u64(from(2)), 0);
    assert!(as_u64(wrapping_sub(neg_from(1), from(1))) == as_u64(neg_from(2)), 0);
    assert!(as_u64(wrapping_sub(from(1000000), from(1))) == 999999, 0);
    assert!(as_u64(wrapping_sub(neg_from(1000000), neg_from(1))) == as_u64(neg_from(999999)), 0);
    assert!(as_u64(wrapping_sub(from(1), from(1000000))) == as_u64(neg_from(999999)), 0);
    assert!(as_u64(wrapping_sub(from(MAX_AS_U64), from(MAX_AS_U64))) == as_u64(from(0)), 0);
    assert!(as_u64(wrapping_sub(from(MAX_AS_U64), from(1))) == as_u64(from(MAX_AS_U64 - 1)), 0);
    assert!(as_u64(wrapping_sub(from(MAX_AS_U64), neg_from(1))) == as_u64(neg_from(MIN_AS_U64)), 0);
    assert!(
        as_u64(wrapping_sub(neg_from(MIN_AS_U64), neg_from(1))) == as_u64(neg_from(MIN_AS_U64 - 1)),
        0,
    );
    assert!(as_u64(wrapping_sub(neg_from(MIN_AS_U64), from(1))) == as_u64(from(MAX_AS_U64)), 0);
}

#[test]
fun test_sub() {
    assert!(as_u64(sub(from(0), from(0))) == 0, 0);
    assert!(as_u64(sub(from(1), from(0))) == 1, 0);
    assert!(as_u64(sub(from(0), from(1))) == as_u64(neg_from(1)), 0);
    assert!(as_u64(sub(from(1), from(1))) == as_u64(neg_from(0)), 0);
    assert!(as_u64(sub(from(1), neg_from(1))) == as_u64(from(2)), 0);
    assert!(as_u64(sub(neg_from(1), from(1))) == as_u64(neg_from(2)), 0);
    assert!(as_u64(sub(from(1000000), from(1))) == 999999, 0);
    assert!(as_u64(sub(neg_from(1000000), neg_from(1))) == as_u64(neg_from(999999)), 0);
    assert!(as_u64(sub(from(1), from(1000000))) == as_u64(neg_from(999999)), 0);
    assert!(as_u64(sub(from(MAX_AS_U64), from(MAX_AS_U64))) == as_u64(from(0)), 0);
    assert!(as_u64(sub(from(MAX_AS_U64), from(1))) == as_u64(from(MAX_AS_U64 - 1)), 0);
    assert!(as_u64(sub(neg_from(MIN_AS_U64), neg_from(1))) == as_u64(neg_from(MIN_AS_U64 - 1)), 0);
}

#[test]
#[expected_failure]
fun test_sub_overflow() {
    sub(from(MAX_AS_U64), neg_from(1));
}

#[test]
#[expected_failure]
fun test_sub_underflow() {
    sub(neg_from(MIN_AS_U64), from(1));
}

#[test]
fun test_mul() {
    assert!(as_u64(mul(from(1), from(1))) == 1, 0);
    assert!(as_u64(mul(from(10), from(10))) == 100, 0);
    assert!(as_u64(mul(from(100), from(100))) == 10000, 0);
    assert!(as_u64(mul(from(10000), from(10000))) == 100000000, 0);

    assert!(as_u64(mul(neg_from(1), from(1))) == as_u64(neg_from(1)), 0);
    assert!(as_u64(mul(neg_from(10), from(10))) == as_u64(neg_from(100)), 0);
    assert!(as_u64(mul(neg_from(100), from(100))) == as_u64(neg_from(10000)), 0);
    assert!(as_u64(mul(neg_from(10000), from(10000))) == as_u64(neg_from(100000000)), 0);

    assert!(as_u64(mul(from(1), neg_from(1))) == as_u64(neg_from(1)), 0);
    assert!(as_u64(mul(from(10), neg_from(10))) == as_u64(neg_from(100)), 0);
    assert!(as_u64(mul(from(100), neg_from(100))) == as_u64(neg_from(10000)), 0);
    assert!(as_u64(mul(from(10000), neg_from(10000))) == as_u64(neg_from(100000000)), 0);
    assert!(as_u64(mul(from(MIN_AS_U64 / 2), neg_from(2))) == as_u64(neg_from(MIN_AS_U64)), 0);
}

#[test]
#[expected_failure]
fun test_mul_overflow() {
    mul(from(MIN_AS_U64 / 2), from(1));
    mul(neg_from(MIN_AS_U64 / 2), neg_from(2));
}

#[test]
fun test_div() {
    assert!(as_u64(i64::div(i64::from(0), i64::from(1))) == 0, 0);
    assert!(as_u64(i64::div(i64::from(10), i64::from(1))) == 10, 0);
    assert!(as_u64(i64::div(i64::from(10), i64::neg_from(1))) == as_u64(i64::neg_from(10)), 0);
    assert!(as_u64(i64::div(i64::neg_from(10), i64::neg_from(1))) == as_u64(i64::from(10)), 0);
    assert!(as_u64(div(neg_from(MIN_AS_U64), from(1))) == MIN_AS_U64, 0);
}

#[test]
#[expected_failure]
fun test_div_overflow() {
    div(neg_from(MIN_AS_U64), neg_from(1));
}

#[test]
fun test_shl() {
    assert!(as_u64(shl(from(10), 0)) == 10, 0);
    assert!(as_u64(shl(neg_from(10), 0)) == as_u64(neg_from(10)), 0);

    assert!(as_u64(shl(from(10), 1)) == 20, 0);
    assert!(as_u64(shl(neg_from(10), 1)) == as_u64(neg_from(20)), 0);

    assert!(as_u64(shl(from(10), 8)) == 2560, 0);
    assert!(as_u64(shl(neg_from(10), 8)) == as_u64(neg_from(2560)), 0);

    assert!(as_u64(shl(from(10), 32)) == 42949672960, 0);
    assert!(as_u64(shl(neg_from(10), 32)) == as_u64(neg_from(42949672960)), 0);

    assert!(as_u64(shl(from(10), 63)) == 0, 0);
    assert!(as_u64(shl(neg_from(10), 63)) == 0, 0);
}

#[test]
fun test_shr() {
    assert!(as_u64(shr(from(10), 0)) == 10, 0);
    assert!(as_u64(shr(neg_from(10), 0)) == as_u64(neg_from(10)), 0);

    assert!(as_u64(shr(from(10), 1)) == 5, 0);
    assert!(as_u64(shr(neg_from(10), 1)) == as_u64(neg_from(5)), 0);

    assert!(as_u64(shr(from(MAX_AS_U64), 8)) == 36028797018963967, 0);
    assert!(as_u64(shr(neg_from(MIN_AS_U64), 8)) == 0xff80000000000000, 0);

    assert!(as_u64(shr(from(MAX_AS_U64), 32)) == 2147483647, 0);
    assert!(as_u64(shr(neg_from(MIN_AS_U64), 32)) == 0xffffffff80000000, 0);

    assert!(as_u64(shr(from(MAX_AS_U64), 63)) == 0, 0);
    assert!(as_u64(shr(neg_from(MIN_AS_U64), 63)) == 0xffffffffffffffff, 0);
}

#[test]
fun test_sign() {
    assert!(sign(neg_from(10)) == 1u8, 0);
    assert!(sign(from(10)) == 0u8, 0);
}

#[test]
fun test_cmp() {
    assert!(cmp(from(1), from(0)) == GT, 0);
    assert!(cmp(from(0), from(1)) == LT, 0);

    assert!(cmp(from(0), neg_from(1)) == GT, 0);
    assert!(cmp(neg_from(0), neg_from(1)) == GT, 0);
    assert!(cmp(neg_from(1), neg_from(0)) == LT, 0);

    assert!(cmp(neg_from(MIN_AS_U64), from(MAX_AS_U64)) == LT, 0);
    assert!(cmp(from(MAX_AS_U64), neg_from(MIN_AS_U64)) == GT, 0);

    assert!(cmp(from(MAX_AS_U64), from(MAX_AS_U64 - 1)) == GT, 0);

    assert!(cmp(neg_from(MIN_AS_U64), neg_from(MIN_AS_U64 - 1)) == LT, 0);
    assert!(cmp(neg_from(MIN_AS_U64 - 1), neg_from(MIN_AS_U64)) == GT, 0);
}

#[test]
fun test_castdown() {
    assert!((1u64 as u8) == 1u8, 0);
}

#[test]
fun test_mod() {
    let mut i = mod(neg_from(2), from(5));
    assert!(cmp(i, neg_from(2)) == EQ, 0);

    i = mod(neg_from(2), neg_from(5));
    assert!(cmp(i, neg_from(2)) == EQ, 0);

    i = mod(from(2), from(5));
    assert!(cmp(i, from(2)) == EQ, 0);

    i = mod(from(2), neg_from(5));
    assert!(cmp(i, from(2)) == EQ, 0);
}

#[test]
fun test_zero() {
    let zero_val = zero();
    assert!(as_u64(zero_val) == 0, 0);
    assert!(!is_neg(zero_val), 1);
    assert!(sign(zero_val) == 0, 2);
}

#[test]
fun test_from_u64() {
    // Test positive numbers
    let pos_val = from_u64(12345);
    assert!(as_u64(pos_val) == 12345, 0);
    assert!(!is_neg(pos_val), 1);
    assert!(sign(pos_val) == 0, 2);

    // Test zero
    let zero_val = from_u64(0);
    assert!(as_u64(zero_val) == 0, 3);
    assert!(!is_neg(zero_val), 4);
    assert!(sign(zero_val) == 0, 5);

    // Test negative numbers (via bit pattern)
    let neg_val = from_u64(0x8000000000000001);
    assert!(as_u64(neg_val) == 0x8000000000000001, 6);
    assert!(is_neg(neg_val), 7);
    assert!(sign(neg_val) == 1, 8);

    // Test maximum value
    let max_val = from_u64(0x7fffffffffffffff);
    assert!(as_u64(max_val) == 0x7fffffffffffffff, 9);
    assert!(!is_neg(max_val), 10);
    assert!(sign(max_val) == 0, 11);
}

#[test]
fun test_is_neg() {
    // Test positive numbers
    assert!(!is_neg(from(123)), 0);
    assert!(!is_neg(from(0)), 1);
    assert!(!is_neg(from(0x7fffffffffffffff)), 2);

    // Test negative numbers
    assert!(is_neg(neg_from(123)), 3);
    assert!(is_neg(neg_from(1)), 4);
    assert!(is_neg(neg_from(0x7fffffffffffffff)), 5);

    // Test negative numbers created via bit pattern
    let neg_bit_pattern = from_u64(0x8000000000000001);
    assert!(is_neg(neg_bit_pattern), 6);
}

#[test]
fun test_eq() {
    // Test equality
    assert!(eq(from(0), from(0)), 0);
    assert!(eq(from(123), from(123)), 1);
    assert!(eq(neg_from(123), neg_from(123)), 2);
    assert!(eq(from(0x7fffffffffffffff), from(0x7fffffffffffffff)), 3);

    // Test inequality
    assert!(!eq(from(0), from(1)), 4);
    assert!(!eq(from(123), from(456)), 5);
    assert!(!eq(from(123), neg_from(123)), 6);
    assert!(!eq(neg_from(123), from(123)), 7);
}

#[test]
fun test_gt() {
    // Test positive number comparison
    assert!(gt(from(2), from(1)), 0);
    assert!(gt(from(100), from(50)), 1);
    assert!(!gt(from(1), from(2)), 2);
    assert!(!gt(from(1), from(1)), 3);

    // Test negative number comparison
    assert!(gt(neg_from(1), neg_from(2)), 4);
    assert!(gt(neg_from(50), neg_from(100)), 5);
    assert!(!gt(neg_from(2), neg_from(1)), 6);
    assert!(!gt(neg_from(1), neg_from(1)), 7);

    // Test positive vs negative comparison
    assert!(gt(from(1), neg_from(1)), 8);
    assert!(!gt(neg_from(1), from(1)), 9);
}

#[test]
fun test_gte() {
    // Test positive number comparison
    assert!(gte(from(2), from(1)), 0);
    assert!(gte(from(1), from(1)), 1);
    assert!(!gte(from(1), from(2)), 2);

    // Test negative number comparison
    assert!(gte(neg_from(1), neg_from(2)), 3);
    assert!(gte(neg_from(1), neg_from(1)), 4);
    assert!(!gte(neg_from(2), neg_from(1)), 5);

    // Test positive vs negative comparison
    assert!(gte(from(1), neg_from(1)), 6);
    assert!(!gte(neg_from(1), from(1)), 7);
}

#[test]
fun test_lt() {
    // Test positive number comparison
    assert!(lt(from(1), from(2)), 0);
    assert!(!lt(from(2), from(1)), 1);
    assert!(!lt(from(1), from(1)), 2);

    // Test negative number comparison
    assert!(lt(neg_from(2), neg_from(1)), 3);
    assert!(!lt(neg_from(1), neg_from(2)), 4);
    assert!(!lt(neg_from(1), neg_from(1)), 5);

    // Test positive vs negative comparison
    assert!(lt(neg_from(1), from(1)), 6);
    assert!(!lt(from(1), neg_from(1)), 7);
}

#[test]
fun test_lte() {
    // Test positive number comparison
    assert!(lte(from(1), from(2)), 0);
    assert!(lte(from(1), from(1)), 1);
    assert!(!lte(from(2), from(1)), 2);

    // Test negative number comparison
    assert!(lte(neg_from(2), neg_from(1)), 3);
    assert!(lte(neg_from(1), neg_from(1)), 4);
    assert!(!lte(neg_from(1), neg_from(2)), 5);

    // Test positive vs negative comparison
    assert!(lte(neg_from(1), from(1)), 6);
    assert!(!lte(from(1), neg_from(1)), 7);
}

#[test]
fun test_or() {
    // Test basic OR operation
    let a = from(10);
    let b = from(12);
    let result = or(a, b);
    assert!(as_u64(result) == 14, 0);

    // Test OR with zero
    let zero_val = zero();
    let num = from(12345);
    let result2 = or(zero_val, num);
    assert!(as_u64(result2) == 12345, 1);

    // Test OR with itself
    let result3 = or(num, num);
    assert!(as_u64(result3) == 12345, 2);

    // Test negative number OR operation
    let neg_a = neg_from(10);
    let neg_b = neg_from(12);
    let result4 = or(neg_a, neg_b);
    // OR result of negative numbers depends on specific bit patterns
    assert!(is_neg(result4), 3);
}

#[test]
fun test_and() {
    // Test basic AND operation
    let a = from(10);
    let b = from(12);
    let result = and(a, b);
    assert!(as_u64(result) == 8, 0);

    // Test AND with zero
    let zero_val = zero();
    let num = from(12345);
    let result2 = and(zero_val, num);
    assert!(as_u64(result2) == 0, 1);

    // Test AND with itself
    let result3 = and(num, num);
    assert!(as_u64(result3) == 12345, 2);

    // Test negative number AND operation
    let neg_a = neg_from(10);
    let neg_b = neg_from(12);
    let result4 = and(neg_a, neg_b);
    // AND result of negative numbers depends on specific bit patterns
    assert!(is_neg(result4), 3);
}

#[test]
#[expected_failure]
fun test_sub_overflow_num2_MIN_AS_U64() {
    sub(from(100), neg_from(MIN_AS_U64));
}
