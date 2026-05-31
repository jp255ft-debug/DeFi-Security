module mmt_v3::bit_math;

use mmt_v3::error;

public fun least_significant_bit(mut value: u256): u8 {
    assert!(value > 0, error::zero());
    let bit_position = 255;
    let mut result = bit_position;
    if (value & (mmt_v3::constants::max_u128() as u256) > 0) {
        result = bit_position - 128;
    } else {
        value = value >> 128;
    };
    if (value & (mmt_v3::constants::max_u64() as u256) > 0) {
        result = result - 64;
    } else {
        value = value >> 64;
    };
    if (value & (mmt_v3::constants::max_u32() as u256) > 0) {
        result = result - 32;
    } else {
        value = value >> 32;
    };
    if (value & (mmt_v3::constants::max_u16() as u256) > 0) {
        result = result - 16;
    } else {
        value = value >> 16;
    };
    if (value & (mmt_v3::constants::max_u8() as u256) > 0) {
        result = result - 8;
    } else {
        value = value >> 8;
    };
    if (value & 15 > 0) {
        result = result - 4;
    } else {
        value = value >> 4;
    };
    if (value & 3 > 0) {
        result = result - 2;
    } else {
        value = value >> 2;
    };
    if (value & 1 > 0) {
        result = result - 1;
    };
    result
}

public fun most_significant_bit(mut value: u256): u8 {
    assert!(value > 0, error::zero());
    let bit_position = 0;
    let mut result = bit_position;
    if (value >= 340282366920938463463374607431768211456) {
        value = value >> 128;
        result = bit_position + 128;
    };
    if (value >= 18446744073709551616) {
        value = value >> 64;
        result = result + 64;
    };
    if (value >= 4294967296) {
        value = value >> 32;
        result = result + 32;
    };
    if (value >= 65536) {
        value = value >> 16;
        result = result + 16;
    };
    if (value >= 256) {
        value = value >> 8;
        result = result + 8;
    };
    if (value >= 16) {
        value = value >> 4;
        result = result + 4;
    };
    if (value >= 4) {
        value = value >> 2;
        result = result + 2;
    };
    if (value >= 2) {
        result = result + 1;
    };
    result
}
