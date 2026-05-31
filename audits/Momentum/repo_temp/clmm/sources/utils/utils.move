module mmt_v3::utils;

use sui::coin::{Self, Coin};

public fun refund<X>(coin: Coin<X>, recipient: address) {
    if (coin::value<X>(&coin) > 0) {
        transfer::public_transfer<Coin<X>>(coin, recipient);
    } else {
        coin::destroy_zero<X>(coin);
    };
}

public fun to_seconds(milliseconds: u64): u64 {
    milliseconds / 1000
}
