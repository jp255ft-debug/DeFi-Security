#[test_only]
module mmt_v3::utils_test;

use mmt_v3::test_helper::USDC;
use mmt_v3::utils::{refund, to_seconds};
use sui::coin;
use sui::test_scenario;

#[test]
fun test_to_seconds() {
    assert!(to_seconds(1000) == 1);
    assert!(to_seconds(2000) == 2);
    assert!(to_seconds(500) == 0);
    assert!(to_seconds(60000) == 60);
    assert!(to_seconds(3600000) == 3600);

    assert!(to_seconds(0) == 0);
    assert!(to_seconds(999) == 0);
    assert!(to_seconds(1001) == 1);

    let large_milliseconds: u64 = 86400000;
    assert!(to_seconds(large_milliseconds) == 86400);

    let very_large_milliseconds: u64 = 31536000000;
    assert!(to_seconds(very_large_milliseconds) == 31536000);
}

#[test]
fun test_refund_with_value() {
    let mut scenario = test_scenario::begin(@0x1);
    let ctx = test_scenario::ctx(&mut scenario);

    let coin_value: u64 = 1000000;
    let coin = coin::mint_for_testing<USDC>(coin_value, ctx);

    let recipient = @0x2;

    refund(coin, recipient);

    test_scenario::end(scenario);
}

#[test]
fun test_refund_zero_value() {
    let mut scenario = test_scenario::begin(@0x1);
    let ctx = test_scenario::ctx(&mut scenario);

    let coin = coin::mint_for_testing<USDC>(0, ctx);

    let recipient = @0x2;

    refund(coin, recipient);

    test_scenario::end(scenario);
}
