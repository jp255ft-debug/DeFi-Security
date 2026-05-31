#[test_only]
module mmt_v3::oracle_test;

use mmt_v3::i32;
use mmt_v3::i64;
use mmt_v3::oracle::{Self, Observation};

#[test]
public fun test_oracle_initialize() {
    let mut observations = vector::empty<Observation>();
    let timestamp: u64 = 1000;

    let (cardinality, cardinality_next) = oracle::initialize(&mut observations, timestamp);

    assert!(cardinality == 1);
    assert!(cardinality_next == 1);
    assert!(vector::length(&observations) == 1);

    let first_obs = vector::borrow(&observations, 0);
    assert!(oracle::timestamp_s(first_obs) == timestamp);
    assert!(oracle::is_initialized(first_obs));
}

#[test]
public fun test_oracle_grow() {
    let mut observations = vector::empty<Observation>();
    let initial_timestamp: u64 = 1000;

    oracle::initialize(&mut observations, initial_timestamp);

    let new_cardinality = oracle::grow(&mut observations, 1, 5);

    assert!(new_cardinality == 5);
    assert!(vector::length(&observations) == 5);

    let mut i = 1;
    while (i < 5) {
        let obs = vector::borrow(&observations, i);
        assert!(!oracle::is_initialized(obs));
        i = i + 1;
    };
}

#[test]
#[expected_failure(abort_code = 22, location = mmt_v3::oracle)]
public fun test_oracle_grow_invalid_size() {
    let mut observations = vector::empty<Observation>();

    oracle::grow(&mut observations, 0, 999);
}

#[test]
#[expected_failure(abort_code = 22, location = mmt_v3::oracle)]
public fun test_oracle_grow_too_large() {
    let mut observations = vector::empty<Observation>();

    oracle::grow(&mut observations, 1, 1000);
}

#[test]
public fun test_oracle_write() {
    let mut observations = vector::empty<Observation>();
    let initial_timestamp: u64 = 1000;

    oracle::initialize(&mut observations, initial_timestamp);

    oracle::grow(&mut observations, 1, 3);

    let current_tick = i32::from(100);
    let liquidity: u128 = 1000000;
    let new_timestamp: u64 = 2000;

    let (new_index, new_cardinality) = oracle::write(
        &mut observations,
        0,
        new_timestamp,
        current_tick,
        liquidity,
        3,
        3,
    );

    assert!(new_index == 1);
    assert!(new_cardinality == 3);

    let new_obs = vector::borrow(&observations, 1);
    assert!(oracle::timestamp_s(new_obs) == new_timestamp);
    assert!(oracle::is_initialized(new_obs));
}

#[test]
public fun test_oracle_observe_single() {
    let mut observations = vector::empty<Observation>();
    let initial_timestamp: u64 = 1000;

    oracle::initialize(&mut observations, initial_timestamp);

    let current_tick = i32::from(100);
    let liquidity: u128 = 1000000;
    let interval: u64 = 0;

    let (tick_cum, sec_per_liquidity) = oracle::observe_single(
        &observations,
        initial_timestamp,
        interval,
        current_tick,
        0,
        liquidity,
        1,
    );

    assert!(i64::eq(tick_cum, i64::zero()));
    assert!(sec_per_liquidity == 0);
}

#[test]
public fun test_oracle_observe() {
    let mut observations = vector::empty<Observation>();
    let initial_timestamp: u64 = 1000;

    oracle::initialize(&mut observations, initial_timestamp);

    let current_tick = i32::from(100);
    let liquidity: u128 = 1000000;
    let mut intervals = vector::empty<u64>();
    vector::push_back(&mut intervals, 0);
    vector::push_back(&mut intervals, 100);

    let (tick_cumulatives, sec_per_liquidity_cumulatives) = oracle::observe(
        &observations,
        2000,
        intervals,
        current_tick,
        0,
        liquidity,
        1,
    );

    assert!(vector::length(&tick_cumulatives) == 2);
    assert!(vector::length(&sec_per_liquidity_cumulatives) == 2);
}

#[test]
#[expected_failure(abort_code = 23, location = mmt_v3::oracle)]
public fun test_oracle_observe_invalid_without_initialize() {
    let observations = vector::empty<Observation>();
    let mut intervals = vector::empty<u64>();
    vector::push_back(&mut intervals, 0u64);

    oracle::observe(
        &observations,
        1000,
        intervals,
        i32::from(100),
        0,
        1000000,
        0,
    );
}

#[test]
public fun test_seconds_per_liquidity_cumulative() {
    let mut observations = vector::empty<Observation>();
    let timestamp: u64 = 1000;
    oracle::initialize(&mut observations, timestamp);
    let obs = vector::borrow(&observations, 0);
    assert!(oracle::seconds_per_liquidity_cumulative(obs) == 0);

    oracle::grow(&mut observations, 1, 3);

    let new_timestamp: u64 = 2000;
    let current_tick = i32::from(100);
    let liquidity: u128 = 1000000;
    let (new_index, _) = oracle::write(
        &mut observations,
        0,
        new_timestamp,
        current_tick,
        liquidity,
        3,
        3,
    );

    let time_diff = new_timestamp - timestamp;
    let expected_value = ((time_diff as u256) << 128) / (liquidity as u256);
    assert!(
        oracle::seconds_per_liquidity_cumulative(vector::borrow(&observations, new_index)) == expected_value,
    );
}

#[test]
public fun test_seconds_per_liquidity_cumulative_with_zero_liquidity() {
    let mut observations = vector::empty<Observation>();
    let initial_timestamp: u64 = 1000;

    oracle::initialize(&mut observations, initial_timestamp);
    oracle::grow(&mut observations, 1, 3);

    let current_tick = i32::from(0);
    let liquidity: u128 = 0;
    let new_timestamp: u64 = 2000;

    let (new_index, _) = oracle::write(
        &mut observations,
        0,
        new_timestamp,
        current_tick,
        liquidity,
        3,
        3,
    );

    let new_obs = vector::borrow(&observations, new_index);
    let new_sec_per_liquidity = oracle::seconds_per_liquidity_cumulative(new_obs);

    // when liquidity is 0, the code sets it to 1
    let expected_time_diff = new_timestamp - initial_timestamp;
    let expected_value = (expected_time_diff as u256) << 128;
    assert!(new_sec_per_liquidity == expected_value);
}

#[test]
public fun test_transform() {
    let mut observations = vector::empty<Observation>();
    let initial_timestamp: u64 = 1000;
    oracle::initialize(&mut observations, initial_timestamp);

    let obs = vector::borrow(&observations, 0);

    let current_tick = i32::from(100);
    let liquidity: u128 = 1000000;
    let new_timestamp: u64 = 2000;
    let new_obs = oracle::transform(obs, new_timestamp, current_tick, liquidity);

    assert!(oracle::timestamp_s(&new_obs) == new_timestamp);
    assert!(
        oracle::tick_cumulative(&new_obs) == i64::from((i32::abs_u32(current_tick) as u64) * (new_timestamp - initial_timestamp)),
    );

    let time_diff = new_timestamp - initial_timestamp;
    let expected_value = ((time_diff as u256) << 128) / (liquidity as u256);
    assert!(oracle::seconds_per_liquidity_cumulative(&new_obs) == expected_value);
}

#[test]
public fun test_get_surrounding_observations_equal_timestamp() {
    let mut observations = vector::empty<Observation>();
    let timestamp: u64 = 1000;

    oracle::initialize(&mut observations, timestamp);
    oracle::grow(&mut observations, 1, 3);

    let current_tick = i32::from(100);
    let liquidity: u128 = 1000000;
    let target_timestamp: u64 = 1000;

    let (earlier_obs, later_obs) = oracle::get_surrounding_observations(
        &observations,
        target_timestamp,
        current_tick,
        0,
        liquidity,
        3,
    );

    assert!(oracle::timestamp_s(&earlier_obs) == target_timestamp);
    assert!(!oracle::is_initialized(&later_obs));
    assert!(oracle::timestamp_s(&later_obs) == 0);
}

#[test]
public fun test_get_surrounding_observations_greater_timestamp() {
    let mut observations = vector::empty<Observation>();
    let timestamp: u64 = 1000;

    oracle::initialize(&mut observations, timestamp);
    oracle::grow(&mut observations, 1, 3);

    let current_tick = i32::from(100);
    let liquidity: u128 = 1000000;
    let target_timestamp: u64 = 1500;

    let (earlier_obs, later_obs) = oracle::get_surrounding_observations(
        &observations,
        target_timestamp,
        current_tick,
        0,
        liquidity,
        3,
    );

    assert!(oracle::timestamp_s(&earlier_obs) == timestamp);
    assert!(oracle::timestamp_s(&later_obs) == target_timestamp);
    assert!(oracle::is_initialized(&later_obs));

    let time_diff = target_timestamp - timestamp;
    let expected_sec_per_liquidity = ((time_diff as u256) << 128) / (liquidity as u256);
    assert!(oracle::seconds_per_liquidity_cumulative(&later_obs) == expected_sec_per_liquidity);
}

#[test]
public fun test_get_surrounding_observations_less_timestamp() {
    let mut observations = vector::empty<Observation>();
    let timestamp: u64 = 200;

    oracle::initialize(&mut observations, timestamp);
    oracle::grow(&mut observations, 1, 5);

    let current_tick = i32::from(100);
    let liquidity: u128 = 1000000;

    let (index1, _) = oracle::write(
        &mut observations,
        0,
        1000,
        current_tick,
        liquidity,
        5,
        5,
    );

    let (index2, _) = oracle::write(
        &mut observations,
        index1,
        1500,
        current_tick,
        liquidity,
        5,
        5,
    );

    let target_timestamp: u64 = 1200;

    let (earlier_obs, later_obs) = oracle::get_surrounding_observations(
        &observations,
        target_timestamp,
        current_tick,
        index2,
        liquidity,
        5,
    );

    assert!(oracle::timestamp_s(&earlier_obs) == 1000);
    assert!(oracle::timestamp_s(&later_obs) == 1500);
    assert!(oracle::is_initialized(&earlier_obs));
    assert!(oracle::is_initialized(&later_obs));
}

#[test]
public fun test_get_surrounding_observations_multiple_observations() {
    let mut observations = vector::empty<Observation>();
    let timestamp: u64 = 1000;

    oracle::initialize(&mut observations, timestamp);
    oracle::grow(&mut observations, 1, 7);

    let current_tick = i32::from(50);
    let liquidity: u128 = 500000;

    let timestamps = vector[1200, 1400, 1600, 1800, 2000];
    let mut current_index = 0;
    let mut i = 0;

    while (i < vector::length(&timestamps)) {
        let (new_index, _) = oracle::write(
            &mut observations,
            current_index,
            *vector::borrow(&timestamps, i),
            current_tick,
            liquidity,
            7,
            7,
        );
        current_index = new_index;
        i = i + 1;
    };

    let target_timestamp: u64 = 1500;

    let (earlier_obs, later_obs) = oracle::get_surrounding_observations(
        &observations,
        target_timestamp,
        current_tick,
        0,
        liquidity,
        7,
    );

    assert!(oracle::timestamp_s(&earlier_obs) == 1000);
    assert!(oracle::timestamp_s(&later_obs) == 1500);
    assert!(oracle::is_initialized(&earlier_obs));
    assert!(oracle::is_initialized(&later_obs));
}

#[test]
#[expected_failure(abort_code = 21, location = mmt_v3::oracle)]
public fun test_get_surrounding_observations_invalid_timestamp() {
    let mut observations = vector::empty<Observation>();
    let timestamp: u64 = 2000;

    oracle::initialize(&mut observations, timestamp);
    oracle::grow(&mut observations, 1, 3);

    let current_tick = i32::from(100);
    let liquidity: u128 = 1000000;
    let target_timestamp: u64 = 1500;

    oracle::get_surrounding_observations(
        &observations,
        target_timestamp,
        current_tick,
        0,
        liquidity,
        3,
    );
}
