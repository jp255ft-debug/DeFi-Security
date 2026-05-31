module mmt_v3::oracle;

use mmt_v3::error;
use mmt_v3::i32::I32;
use mmt_v3::i64::{Self, I64};

public struct Observation has copy, drop, store {
    timestamp_s: u64,
    tick_cumulative: I64,
    seconds_per_liquidity_cumulative: u256,
    initialized: bool,
}

#[allow(unused_assignment)]
public fun binary_search(
    observations: &vector<Observation>,
    target_timestamp: u64,
    start_index: u64,
    length: u64,
): (Observation, Observation) {
    let next_index = (start_index + 1) % length;
    let mut low = next_index;
    let mut high = next_index + length - 1;
    let mut mid_observation = default();
    let mut next_observation = default();
    loop {
        let mid_index = (low + high) / 2;
        mid_observation = try_get_observation(observations, mid_index % length);

        // if mid tick is not initialised, skip it by moving low to mid + 1.
        if (!mid_observation.initialized) {
            low = mid_index + 1;
            continue
        };

        // get next observation
        next_observation = try_get_observation(observations, (mid_index + 1) % length);

        // if target price is in between mid and next index then break.
        if (
            mid_observation.timestamp_s <= target_timestamp && target_timestamp <= next_observation.timestamp_s
        ) {
            break
        } else if (mid_observation.timestamp_s < target_timestamp) {
            // if mid timestamp < target time, search in later half of the array
            low = mid_index + 1;
        } else {
            // if mid timestamp > target time, search in first half of the array to narrow down search.
            high = mid_index - 1;
        };
    };

    (mid_observation, next_observation)
}

fun default(): Observation {
    Observation {
        timestamp_s: 0,
        tick_cumulative: i64::zero(),
        seconds_per_liquidity_cumulative: 0,
        initialized: false,
    }
}

public fun get_surrounding_observations(
    observations: &vector<Observation>,
    target_timestamp: u64,
    current_tick: I32,
    start_index: u64,
    liquidity: u128,
    observation_cardinality: u64,
): (Observation, Observation) {
    let mut observation = try_get_observation(observations, start_index);
    if (observation.timestamp_s <= target_timestamp) {
        if (observation.timestamp_s == target_timestamp) {
            return (observation, default())
        };
        return (observation, transform(&observation, target_timestamp, current_tick, liquidity))
    };
    observation = try_get_observation(observations, (start_index + 1) % observation_cardinality);
    if (!observation.initialized) {
        observation = *vector::borrow<Observation>(observations, 0);
    };
    assert!(observation.timestamp_s <= target_timestamp, error::invalid_observation_timestamp());

    binary_search(observations, target_timestamp, start_index, observation_cardinality)
}

public fun grow(observations: &mut vector<Observation>, mut current_size: u64, new_size: u64): u64 {
    assert!(current_size > 0 && new_size < 1000, error::grow_obs_check_failed());

    if (new_size <= current_size) {
        return current_size
    };
    while (current_size < new_size) {
        let new_observation = default();
        vector::push_back<Observation>(observations, new_observation);
        current_size = current_size + 1;
    };
    new_size
}

public fun initialize(observations: &mut vector<Observation>, timestamp: u64): (u64, u64) {
    let new_observation = Observation {
        timestamp_s: timestamp,
        tick_cumulative: i64::zero(),
        seconds_per_liquidity_cumulative: 0,
        initialized: true,
    };
    vector::push_back<Observation>(observations, new_observation);
    (1, 1)
}

public fun is_initialized(observation: &Observation): bool {
    observation.initialized
}

public fun observe(
    observations: &vector<Observation>,
    timestamp: u64,
    intervals: vector<u64>,
    current_tick: I32,
    start_index: u64,
    liquidity: u128,
    total_observations: u64,
): (vector<I64>, vector<u256>) {
    assert!(total_observations > 0, error::observe_checks());

    let mut cumulative_liquidity = vector::empty<u256>();
    let mut tick_cumulative = vector::empty<I64>();
    let mut index = 0;
    while (index < vector::length<u64>(&intervals)) {
        let (tick_cum, sec_per_liquidity) = observe_single(
            observations,
            timestamp,
            *vector::borrow<u64>(&intervals, index),
            current_tick,
            start_index,
            liquidity,
            total_observations,
        );
        vector::push_back<I64>(&mut tick_cumulative, tick_cum);
        vector::push_back<u256>(&mut cumulative_liquidity, sec_per_liquidity);
        index = index + 1;
    };
    (tick_cumulative, cumulative_liquidity)
}

public fun observe_single(
    observations: &vector<Observation>,
    timestamp: u64,
    interval: u64,
    current_tick: I32,
    start_index: u64,
    liquidity: u128,
    observation_cardinality: u64,
): (I64, u256) {
    if (interval == 0) {
        let mut current_observation = try_get_observation(observations, start_index);
        if (current_observation.timestamp_s != timestamp) {
            let temp_observation = &current_observation;
            current_observation = transform(temp_observation, timestamp, current_tick, liquidity);
        };
        return (
            current_observation.tick_cumulative,
            current_observation.seconds_per_liquidity_cumulative,
        )
    };
    let previous_timestamp = timestamp - interval;
    let (earlier_observation, later_observation) = get_surrounding_observations(
        observations,
        previous_timestamp,
        current_tick,
        start_index,
        liquidity,
        observation_cardinality,
    );
    let later_obs = later_observation;
    let earlier_obs = earlier_observation;
    if (previous_timestamp == earlier_obs.timestamp_s) {
        (earlier_obs.tick_cumulative, earlier_obs.seconds_per_liquidity_cumulative)
    } else {
        let (tick_cum, sec_per_liquidity) = if (previous_timestamp == later_obs.timestamp_s) {
            (later_obs.tick_cumulative, later_obs.seconds_per_liquidity_cumulative)
        } else {
            let time_diff = later_obs.timestamp_s - earlier_obs.timestamp_s;
            let weight = previous_timestamp - earlier_obs.timestamp_s;
            (
                i64::add(
                    earlier_obs.tick_cumulative,
                    i64::mul(
                        i64::div(
                            i64::sub(later_obs.tick_cumulative, earlier_obs.tick_cumulative),
                            i64::from(time_diff),
                        ),
                        i64::from(weight),
                    ),
                ),
                earlier_obs.seconds_per_liquidity_cumulative + (later_obs.seconds_per_liquidity_cumulative - earlier_obs.seconds_per_liquidity_cumulative) * (weight as u256) / (time_diff as u256),
            )
        };
        (tick_cum, sec_per_liquidity)
    }
}

public fun seconds_per_liquidity_cumulative(observation: &Observation): u256 {
    observation.seconds_per_liquidity_cumulative
}

public fun tick_cumulative(observation: &Observation): I64 {
    observation.tick_cumulative
}

public fun timestamp_s(observation: &Observation): u64 {
    observation.timestamp_s
}

public fun transform(
    observation: &Observation,
    timestamp: u64,
    current_tick: I32,
    liquidity: u128,
): Observation {
    let tick_change = if (mmt_v3::i32::is_neg(current_tick)) {
        i64::neg_from(mmt_v3::i32::abs_u32(current_tick) as u64)
    } else {
        i64::from(mmt_v3::i32::abs_u32(current_tick) as u64)
    };
    let time_diff = timestamp - observation.timestamp_s;
    let adjusted_liquidity = if (liquidity == 0) { 1 } else { liquidity };
    Observation {
        timestamp_s: timestamp,
        tick_cumulative: i64::add(
            observation.tick_cumulative,
            i64::mul(tick_change, i64::from(time_diff)),
        ),
        seconds_per_liquidity_cumulative: mmt_v3::math_u256::overflow_add(
            observation.seconds_per_liquidity_cumulative,
            ((time_diff as u256) << 128) / (adjusted_liquidity as u256),
        ),
        initialized: true,
    }
}

fun try_get_observation(observations: &vector<Observation>, index: u64): Observation {
    if (index >= vector::length<Observation>(observations)) {
        default()
    } else {
        *vector::borrow<Observation>(observations, index)
    }
}

public fun write(
    observations: &mut vector<Observation>,
    observation_index: u64,
    timestamp: u64,
    current_tick: I32,
    liquidity: u128,
    observation_cardinality: u64,
    observation_cardinality_next: u64,
): (u64, u64) {
    let current_observation = vector::borrow<Observation>(observations, observation_index);
    if (current_observation.timestamp_s == timestamp) {
        return (observation_index, observation_cardinality)
    };
    let new_observation_cardinality = if (
        observation_cardinality_next > observation_cardinality && 
            observation_index == observation_cardinality - 1
    ) {
        observation_cardinality_next
    } else {
        observation_cardinality
    };
    let new_observation_index = (observation_index + 1) % new_observation_cardinality;
    *vector::borrow_mut<Observation>(observations, new_observation_index) =
        transform(
            current_observation,
            timestamp,
            current_tick,
            liquidity,
        );
    (new_observation_index, new_observation_cardinality)
}
