#[test_only]
module mmt_v3::full_math_u64_test;

use mmt_v3::full_math_u64;

#[test]
fun test_full_mul() {
    assert!(full_math_u64::full_mul(0, 10) == 0);
    assert!(full_math_u64::full_mul(10, 0) == 0);
    assert!(full_math_u64::full_mul(10, 10) == 100);
    assert!(full_math_u64::full_mul(9999, 10) == 99990);
    assert!(full_math_u64::full_mul(0xffffffffffffffff, 0) == 0);
    assert!(full_math_u64::full_mul(0xffffffffffffffff, 1) == 0xffffffffffffffff);
    assert!(
        full_math_u64::full_mul(0xffffffffffffffff, 0xffffffffffffffff) == 0xfffffffffffffffe0000000000000001,
    );
}

#[test]
fun test_mul_div_floor() {
    assert!(full_math_u64::mul_div_floor(6, 7, 3) == 14);
    assert!(full_math_u64::mul_div_floor(10, 20, 5) == 40);
    assert!(full_math_u64::mul_div_floor(0, 100, 10) == 0);
    assert!(full_math_u64::mul_div_floor(100, 0, 10) == 0);
    assert!(full_math_u64::mul_div_floor(0xffffffffffffffff, 1, 2) == 0x7fffffffffffffff);
    assert!(full_math_u64::mul_div_floor(0xffffffffffffffff, 2, 3) == 0xaaaaaaaaaaaaaaaa);
    assert!(full_math_u64::mul_div_floor(1, 1, 3) == 0);
    assert!(full_math_u64::mul_div_floor(2, 1, 3) == 0);
}

#[test]
fun test_mul_div_round() {
    assert!(full_math_u64::mul_div_round(6, 7, 3) == 14);
    assert!(full_math_u64::mul_div_round(10, 20, 5) == 40);
    assert!(full_math_u64::mul_div_round(0, 100, 10) == 0);
    assert!(full_math_u64::mul_div_round(100, 0, 10) == 0);
    assert!(full_math_u64::mul_div_round(0xffffffffffffffff, 1, 2) == 0x8000000000000000);
    assert!(full_math_u64::mul_div_round(0xffffffffffffffff, 2, 3) == 0xaaaaaaaaaaaaaaaa);
    assert!(full_math_u64::mul_div_round(1, 1, 3) == 0); // 1/3 = 0.33... rounds down
    assert!(full_math_u64::mul_div_round(2, 1, 3) == 1); // 2/3 = 0.66... rounds up
}

#[test]
fun test_mul_div_ceil() {
    assert!(full_math_u64::mul_div_ceil(6, 7, 3) == 14);
    assert!(full_math_u64::mul_div_ceil(10, 20, 5) == 40);
    assert!(full_math_u64::mul_div_ceil(0, 100, 10) == 0);
    assert!(full_math_u64::mul_div_ceil(100, 0, 10) == 0);
    assert!(full_math_u64::mul_div_ceil(0xffffffffffffffff, 1, 2) == 0x8000000000000000);
    assert!(full_math_u64::mul_div_ceil(0xffffffffffffffff, 2, 3) == 0xaaaaaaaaaaaaaaaa);
    // Test ceiling behavior
    assert!(full_math_u64::mul_div_ceil(1, 1, 3) == 1); // 1/3 = 0.33... ceils to 1
    assert!(full_math_u64::mul_div_ceil(2, 1, 3) == 1); // 2/3 = 0.66... ceils to 1
    assert!(full_math_u64::mul_div_ceil(3, 1, 3) == 1); // 3/3 = 1.0 ceils to 1
}

#[test]
fun test_mul_shr() {
    assert!(full_math_u64::mul_shr(10, 10, 0) == 100);
    assert!(full_math_u64::mul_shr(10, 10, 1) == 50);
    assert!(full_math_u64::mul_shr(10, 10, 2) == 25);
    assert!(full_math_u64::mul_shr(0, 100, 5) == 0);
    assert!(full_math_u64::mul_shr(100, 0, 5) == 0);
    assert!(full_math_u64::mul_shr(0xffffffffffffffff, 1, 1) == 0x7fffffffffffffff);
    assert!(full_math_u64::mul_shr(0xffffffffffffffff, 2, 2) == 0x7fffffffffffffff);
    assert!(
        full_math_u64::mul_shr(0xffffffffffffffff, 0xffffffffffffffff, 64) == 0xfffffffffffffffe,
    );
}

#[test]
fun test_mul_shl() {
    assert!(full_math_u64::mul_shl(10, 10, 0) == 100);
    assert!(full_math_u64::mul_shl(10, 10, 1) == 200);
    assert!(full_math_u64::mul_shl(10, 10, 2) == 400);
    assert!(full_math_u64::mul_shl(0, 100, 5) == 0);
    assert!(full_math_u64::mul_shl(100, 0, 5) == 0);
    assert!(full_math_u64::mul_shl(1, 1, 63) == 0x8000000000000000);
    assert!(full_math_u64::mul_shl(0x1000000000000000, 1, 1) == 0x2000000000000000);
}

#[test]
#[expected_failure(abort_code = 200, location = mmt_v3::full_math_u64)]
fun test_mul_div_floor_zero_denom() {
    full_math_u64::mul_div_floor(6, 7, 0);
}

#[test]
#[expected_failure]
fun test_mul_div_round_zero_denom() {
    full_math_u64::mul_div_round(6, 7, 0);
}

#[test]
#[expected_failure]
fun test_mul_div_ceil_zero_denom() {
    full_math_u64::mul_div_ceil(6, 7, 0);
}
