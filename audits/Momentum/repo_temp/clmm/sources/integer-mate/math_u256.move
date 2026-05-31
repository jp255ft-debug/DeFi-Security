module mmt_v3::math_u256;

use mmt_v3::integer_error;

const MAX_U256: u256 = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

public fun div_mod(num: u256, denom: u256): (u256, u256) {
    let p = num / denom;
    let r: u256 = num - (p * denom);
    (p, r)
}

public fun shlw(n: u256): u256 {
    n << 64
}

public fun shrw(n: u256): u256 {
    n >> 64
}

public fun checked_shlw(n: u256): (u256, bool) {
    let mask = 1 << 192;
    if (n >= mask) {
        (0, true)
    } else {
        ((n << 64), false)
    }
}

public fun div_round(num: u256, denom: u256, round_up: bool): u256 {
    assert!(denom > 0, integer_error::div_by_zero());

    let quotient = num / denom;
    let remainer = num % denom;
    if (round_up && (remainer > 0)) {
        return (quotient + 1)
    };
    quotient
}

public fun add_check(num1: u256, num2: u256): bool {
    (MAX_U256 - num1 >= num2)
}

public fun overflow_add(value1: u256, value2: u256): u256 {
    if (!add_check(value1, value2)) {
        value2 - (MAX_U256 - value1) - 1
    } else {
        value1 + value2
    }
}
