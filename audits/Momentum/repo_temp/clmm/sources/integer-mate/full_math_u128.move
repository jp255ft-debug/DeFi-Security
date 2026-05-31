module mmt_v3::full_math_u128;

public fun full_mul(value1: u128, value2: u128): u256 {
    (value1 as u256) * (value2 as u256)
}

/// \[Deprecated\] Please use `max` from `math_u128` instead.
public fun max(value1: u128, value2: u128): u128 {
    if (value1 > value2) {
        value1
    } else {
        value2
    }
}

/// \[Deprecated\] Please use `min` from `math_u128` instead.
public fun min(value1: u128, value2: u128): u128 {
    if (value1 < value2) {
        value1
    } else {
        value2
    }
}

public fun mul_div_ceil(numerator: u128, multiplier: u128, denominator: u128): u128 {
    ((full_mul(numerator, multiplier) + (denominator as u256) - 1) / (denominator as u256)) as u128
}

public fun mul_div_floor(numerator: u128, multiplier: u128, denominator: u128): u128 {
    (full_mul(numerator, multiplier) / (denominator as u256)) as u128
}

public fun mul_div_round(numerator: u128, multiplier: u128, denominator: u128): u128 {
    (
        (full_mul(numerator, multiplier) + ((denominator as u256) >> 1)) / (denominator as u256),
    ) as u128
}

public fun mul_shl(value1: u128, value2: u128, shift_amount: u8): u128 {
    (full_mul(value1, value2) << shift_amount) as u128
}

public fun mul_shr(value1: u128, value2: u128, shift_amount: u8): u128 {
    (full_mul(value1, value2) >> shift_amount) as u128
}

/// \[Deprecated\] Please use `overflowing_add` from `math_u128` instead.
public fun overflowing_add(value1: u128, value2: u128): (u128, bool) {
    let result = (value1 as u256) + (value2 as u256);
    if (result > (340282366920938463463374607431768211455u256)) {
        ((result & 340282366920938463463374607431768211455) as u128, true)
    } else {
        (result as u128, false)
    }
}

/// \[Deprecated\] Please use `overflowing_sub` from `math_u128` instead.
public fun overflowing_sub(value1: u128, value2: u128): (u128, bool) {
    if (value1 >= value2) {
        (value1 - value2, false)
    } else {
        (340282366920938463463374607431768211455 - value2 + value1 + 1, true)
    }
}

/// \[Deprecated\] Please use `wrapping_add` from `math_u128` instead.
public fun wrapping_add(value1: u128, value2: u128): u128 {
    let (result, _) = overflowing_add(value1, value2);
    result
}

/// \[Deprecated\] Please use `wrapping_sub` from `math_u128` instead.
public fun wrapping_sub(value1: u128, value2: u128): u128 {
    let (result, _) = overflowing_sub(value1, value2);
    result
}
