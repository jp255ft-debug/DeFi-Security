module mmt_v3::comparator;

use std::bcs;

public struct Result has drop {
    inner: u8,
}

public fun compare<X>(value1: &X, value2: &X): Result {
    compare_u8_vector(bcs::to_bytes<X>(value1), bcs::to_bytes<X>(value2))
}

public fun compare_u8_vector(vec1: vector<u8>, vec2: vector<u8>): Result {
    let len1 = vector::length<u8>(&vec1);
    let len2 = vector::length<u8>(&vec2);
    let mut index = 0;
    while (index < len1 && index < len2) {
        let byte1 = *vector::borrow<u8>(&vec1, index);
        let byte2 = *vector::borrow<u8>(&vec2, index);
        if (byte1 < byte2) {
            return Result { inner: 1 }
        };
        if (byte1 > byte2) {
            return Result { inner: 2 }
        };
        index = index + 1;
    };
    if (len1 < len2) {
        Result { inner: 1 }
    } else {
        if (len1 > len2) {
            Result { inner: 2 }
        } else {
            Result { inner: 0 }
        }
    }
}

public fun is_equal(result: &Result): bool {
    result.inner == 0
}

public fun is_greater_than(result: &Result): bool {
    result.inner == 2
}

public fun is_smaller_than(result: &Result): bool {
    result.inner == 1
}
