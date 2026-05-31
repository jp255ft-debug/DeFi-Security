#[test_only]
module mmt_v3::i32_test;

use mmt_v3::i32::{
    from,
    neg_from,
    as_u32,
    wrapping_add,
    add,
    wrapping_sub,
    sub,
    mul,
    div,
    shl,
    shr,
    sign,
    cmp,
    lt,
    abs,
    mod,
    abs_u32
};

const MIN_AS_U32: u32 = 1 << 31;
const MAX_AS_U32: u32 = 0x7fffffff;

const LT: u8 = 0;
const EQ: u8 = 1;
const GT: u8 = 2;

#[test]
fun test_from_ok() {
    assert!(as_u32(from(0)) == 0);
    assert!(as_u32(from(10)) == 10);
}

#[test]
#[expected_failure]
fun test_from_overflow() {
    as_u32(from(MIN_AS_U32));
    as_u32(from(0xffffffff));
}

#[test]
fun test_neg_from() {
    assert!(as_u32(neg_from(0)) == 0);
    assert!(as_u32(neg_from(1)) == 0xffffffff);
    assert!(as_u32(neg_from(0x7fffffff)) == 0x80000001);
    assert!(as_u32(neg_from(MIN_AS_U32)) == MIN_AS_U32);
}

#[test]
#[expected_failure]
fun test_neg_from_overflow() {
    neg_from(0x80000001);
}

#[test]
fun test_abs() {
    assert!(as_u32(from(10)) == 10u32);
    assert!(as_u32(abs(neg_from(10))) == 10u32);
    assert!(as_u32(abs(neg_from(0))) == 0u32);
    assert!(as_u32(abs(neg_from(0x7fffffff))) == 0x7fffffff);
    assert!(as_u32(neg_from(MIN_AS_U32)) == MIN_AS_U32);
}

#[test]
#[expected_failure]
fun test_abs_overflow() {
    abs(neg_from(1 << 31));
}

#[test]
fun test_wrapping_add() {
    assert!(as_u32(wrapping_add(from(0), from(1))) == 1);
    assert!(as_u32(wrapping_add(from(1), from(0))) == 1);
    assert!(as_u32(wrapping_add(from(10000), from(99999))) == 109999);
    assert!(as_u32(wrapping_add(from(99999), from(10000))) == 109999);
    assert!(as_u32(wrapping_add(from(MAX_AS_U32 - 1), from(1))) == MAX_AS_U32);
    assert!(as_u32(wrapping_add(from(0), from(0))) == 0);

    assert!(as_u32(wrapping_add(neg_from(0), neg_from(0))) == 0);
    assert!(as_u32(wrapping_add(neg_from(1), neg_from(0))) == 0xffffffff);
    assert!(as_u32(wrapping_add(neg_from(0), neg_from(1))) == 0xffffffff);
    assert!(as_u32(wrapping_add(neg_from(10000), neg_from(99999))) == 0xfffe5251);
    assert!(as_u32(wrapping_add(neg_from(99999), neg_from(10000))) == 0xfffe5251);
    assert!(as_u32(wrapping_add(neg_from(MIN_AS_U32 - 1), neg_from(1))) == MIN_AS_U32);

    assert!(as_u32(wrapping_add(from(0), neg_from(0))) == 0);
    assert!(as_u32(wrapping_add(neg_from(0), from(0))) == 0);
    assert!(as_u32(wrapping_add(neg_from(1), from(1))) == 0);
    assert!(as_u32(wrapping_add(from(1), neg_from(1))) == 0);
    assert!(as_u32(wrapping_add(from(10000), neg_from(99999))) == 0xfffea071);
    assert!(as_u32(wrapping_add(from(99999), neg_from(10000))) == 89999);
    assert!(as_u32(wrapping_add(neg_from(MIN_AS_U32), from(1))) == 0x80000001);
    assert!(as_u32(wrapping_add(from(MAX_AS_U32), neg_from(1))) == MAX_AS_U32 - 1);

    assert!(as_u32(wrapping_add(from(MAX_AS_U32), from(1))) == MIN_AS_U32);
}

#[test]
fun test_add() {
    assert!(as_u32(add(from(0), from(0))) == 0);
    assert!(as_u32(add(from(0), from(1))) == 1);
    assert!(as_u32(add(from(1), from(0))) == 1);
    assert!(as_u32(add(from(10000), from(99999))) == 109999);
    assert!(as_u32(add(from(99999), from(10000))) == 109999);
    assert!(as_u32(add(from(MAX_AS_U32 - 1), from(1))) == MAX_AS_U32);

    assert!(as_u32(add(neg_from(0), neg_from(0))) == 0);
    assert!(as_u32(add(neg_from(1), neg_from(0))) == 0xffffffff);
    assert!(as_u32(add(neg_from(0), neg_from(1))) == 0xffffffff);
    assert!(as_u32(add(neg_from(10000), neg_from(99999))) == 0xfffe5251);
    assert!(as_u32(add(neg_from(99999), neg_from(10000))) == 0xfffe5251);
    assert!(as_u32(add(neg_from(MIN_AS_U32 - 1), neg_from(1))) == MIN_AS_U32);

    assert!(as_u32(add(from(0), neg_from(0))) == 0);
    assert!(as_u32(add(neg_from(0), from(0))) == 0);
    assert!(as_u32(add(neg_from(1), from(1))) == 0);
    assert!(as_u32(add(from(1), neg_from(1))) == 0);
    assert!(as_u32(add(from(10000), neg_from(99999))) == 0xfffea071);
    assert!(as_u32(add(from(99999), neg_from(10000))) == 89999);
    assert!(as_u32(add(neg_from(MIN_AS_U32), from(1))) == 0x80000001);
    assert!(as_u32(add(from(MAX_AS_U32), neg_from(1))) == MAX_AS_U32 - 1);
}

#[test]
#[expected_failure]
fun test_add_overflow() {
    add(from(MAX_AS_U32), from(1));
}

#[test]
#[expected_failure]
fun test_add_underflow() {
    add(neg_from(MIN_AS_U32), neg_from(1));
}

#[test]
fun test_wrapping_sub() {
    assert!(as_u32(wrapping_sub(from(0), from(0))) == 0);
    assert!(as_u32(wrapping_sub(from(1), from(0))) == 1);
    assert!(as_u32(wrapping_sub(from(0), from(1))) == as_u32(neg_from(1)));
    assert!(as_u32(wrapping_sub(from(1), from(1))) == as_u32(neg_from(0)));
    assert!(as_u32(wrapping_sub(from(1), neg_from(1))) == as_u32(from(2)));
    assert!(as_u32(wrapping_sub(neg_from(1), from(1))) == as_u32(neg_from(2)));
    assert!(as_u32(wrapping_sub(from(1000000), from(1))) == 999999);
    assert!(as_u32(wrapping_sub(neg_from(1000000), neg_from(1))) == as_u32(neg_from(999999)));
    assert!(as_u32(wrapping_sub(from(1), from(1000000))) == as_u32(neg_from(999999)));
    assert!(as_u32(wrapping_sub(from(MAX_AS_U32), from(MAX_AS_U32))) == as_u32(from(0)));
    assert!(as_u32(wrapping_sub(from(MAX_AS_U32), from(1))) == as_u32(from(MAX_AS_U32 - 1)));
    assert!(as_u32(wrapping_sub(from(MAX_AS_U32), neg_from(1))) == as_u32(neg_from(MIN_AS_U32)));
    assert!(
        as_u32(wrapping_sub(neg_from(MIN_AS_U32), neg_from(1))) == as_u32(neg_from(MIN_AS_U32 - 1)),
    );
    assert!(as_u32(wrapping_sub(neg_from(MIN_AS_U32), from(1))) == as_u32(from(MAX_AS_U32)));
}

#[test]
fun test_sub() {
    assert!(as_u32(sub(from(0), from(0))) == 0);
    assert!(as_u32(sub(from(1), from(0))) == 1);
    assert!(as_u32(sub(from(0), from(1))) == as_u32(neg_from(1)));
    assert!(as_u32(sub(from(1), from(1))) == as_u32(neg_from(0)));
    assert!(as_u32(sub(from(1), neg_from(1))) == as_u32(from(2)));
    assert!(as_u32(sub(neg_from(1), from(1))) == as_u32(neg_from(2)));
    assert!(as_u32(sub(from(1000000), from(1))) == 999999);
    assert!(as_u32(sub(neg_from(1000000), neg_from(1))) == as_u32(neg_from(999999)));
    assert!(as_u32(sub(from(1), from(1000000))) == as_u32(neg_from(999999)));
    assert!(as_u32(sub(from(MAX_AS_U32), from(MAX_AS_U32))) == as_u32(from(0)));
    assert!(as_u32(sub(from(MAX_AS_U32), from(1))) == as_u32(from(MAX_AS_U32 - 1)));
    assert!(as_u32(sub(neg_from(MIN_AS_U32), neg_from(1))) == as_u32(neg_from(MIN_AS_U32 - 1)));
}

#[test]
#[expected_failure]
fun test_sub_overflow() {
    sub(from(MAX_AS_U32), neg_from(1));
}

#[test]
#[expected_failure]
fun test_sub_underflow() {
    sub(neg_from(MIN_AS_U32), from(1));
}

#[test]
fun test_mul() {
    assert!(as_u32(mul(from(1), from(1))) == 1);
    assert!(as_u32(mul(from(10), from(10))) == 100);
    assert!(as_u32(mul(from(100), from(100))) == 10000);
    assert!(as_u32(mul(from(10000), from(10000))) == 100000000);

    assert!(as_u32(mul(neg_from(1), from(1))) == as_u32(neg_from(1)));
    assert!(as_u32(mul(neg_from(10), from(10))) == as_u32(neg_from(100)));
    assert!(as_u32(mul(neg_from(100), from(100))) == as_u32(neg_from(10000)));
    assert!(as_u32(mul(neg_from(10000), from(10000))) == as_u32(neg_from(100000000)));

    assert!(as_u32(mul(from(1), neg_from(1))) == as_u32(neg_from(1)));
    assert!(as_u32(mul(from(10), neg_from(10))) == as_u32(neg_from(100)));
    assert!(as_u32(mul(from(100), neg_from(100))) == as_u32(neg_from(10000)));
    assert!(as_u32(mul(from(10000), neg_from(10000))) == as_u32(neg_from(100000000)));
    assert!(as_u32(mul(from(MIN_AS_U32 / 2), neg_from(2))) == as_u32(neg_from(MIN_AS_U32)));
}

#[test]
#[expected_failure]
fun test_mul_overflow() {
    mul(from(MIN_AS_U32 / 2), from(1));
    mul(neg_from(MIN_AS_U32 / 2), neg_from(2));
}

#[test]
fun test_div() {
    assert!(as_u32(div(from(0), from(1))) == 0);
    assert!(as_u32(div(from(10), from(1))) == 10);
    assert!(as_u32(div(from(10), neg_from(1))) == as_u32(neg_from(10)));
    assert!(as_u32(div(neg_from(10), neg_from(1))) == as_u32(from(10)));

    assert!(abs_u32(neg_from(MIN_AS_U32)) == MIN_AS_U32);
    assert!(as_u32(div(neg_from(MIN_AS_U32), from(1))) == MIN_AS_U32);
}

#[test]
#[expected_failure]
fun test_div_overflow() {
    div(neg_from(MIN_AS_U32), neg_from(1));
}

#[test]
fun test_shl() {
    assert!(as_u32(shl(from(10), 0)) == 10);
    assert!(as_u32(shl(neg_from(10), 0)) == as_u32(neg_from(10)));

    assert!(as_u32(shl(from(10), 1)) == 20);
    assert!(as_u32(shl(neg_from(10), 1)) == as_u32(neg_from(20)));

    assert!(as_u32(shl(from(10), 8)) == 2560);
    assert!(as_u32(shl(neg_from(10), 8)) == as_u32(neg_from(2560)));

    assert!(as_u32(shl(from(10), 31)) == 0);
    assert!(as_u32(shl(neg_from(10), 31)) == 0);
}

#[test]
fun test_shr() {
    assert!(as_u32(shr(from(10), 0)) == 10);
    assert!(as_u32(shr(neg_from(10), 0)) == as_u32(neg_from(10)));

    assert!(as_u32(shr(from(10), 1)) == 5);
    assert!(as_u32(shr(neg_from(10), 1)) == as_u32(neg_from(5)));

    assert!(as_u32(shr(from(MAX_AS_U32), 8)) == MAX_AS_U32 >> 8);
    assert!(as_u32(shr(neg_from(MIN_AS_U32), 8)) == 0xff800000);
}

#[test]
fun test_sign() {
    assert!(sign(neg_from(10)) == 1u8);
    assert!(sign(from(10)) == 0u8);
}

#[test]
fun test_cmp() {
    assert!(cmp(from(1), from(0)) == GT);
    assert!(cmp(from(0), from(1)) == LT);

    assert!(cmp(from(0), neg_from(1)) == GT);
    assert!(cmp(neg_from(0), neg_from(1)) == GT);
    assert!(cmp(neg_from(1), neg_from(0)) == LT);
    assert!(!lt(from(5347), neg_from(765)));

    assert!(cmp(neg_from(MIN_AS_U32), from(MAX_AS_U32)) == LT);
    assert!(cmp(from(MAX_AS_U32), neg_from(MIN_AS_U32)) == GT);

    assert!(cmp(from(MAX_AS_U32), from(MAX_AS_U32 - 1)) == GT);
    assert!(cmp(from(MAX_AS_U32 - 1), from(MAX_AS_U32)) == LT);

    assert!(cmp(neg_from(MIN_AS_U32), neg_from(MIN_AS_U32 - 1)) == LT);
    assert!(cmp(neg_from(MIN_AS_U32 - 1), neg_from(MIN_AS_U32)) == GT);
}

#[test]
fun test_castdown() {
    assert!((1u32 as u8) == 1u8);
}

#[test]
fun test_mod() {
    let mut i = mod(neg_from(2), from(5));
    assert!(cmp(i, neg_from(2)) == EQ);

    i = mod(neg_from(2), neg_from(5));
    assert!(cmp(i, neg_from(2)) == EQ);

    i = mod(from(2), from(5));
    assert!(cmp(i, from(2)) == EQ);

    i = mod(from(2), neg_from(5));
    assert!(cmp(i, from(2)) == EQ);
}

#[test]
#[expected_failure]
fun test_sub_overflow_num2_MIN_AS_U32() {
    sub(from(100), neg_from(MIN_AS_U32));
}
