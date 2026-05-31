module mmt_v3::position;

use mmt_v3::constants;
use mmt_v3::error;
use mmt_v3::i128::I128;
use mmt_v3::i32::I32;
use std::string;
use std::type_name::TypeName;
use sui::display;
use sui::package;

#[allow(unused_field)]
public struct POSITION has drop {
    dummy_field: bool,
}

public struct Position has key, store {
    id: UID,
    pool_id: ID,
    fee_rate: u64,
    type_x: TypeName,
    type_y: TypeName,
    tick_lower_index: I32,
    tick_upper_index: I32,
    liquidity: u128,
    fee_growth_inside_x_last: u128,
    fee_growth_inside_y_last: u128,
    owed_coin_x: u64,
    owed_coin_y: u64,
    reward_infos: vector<PositionRewardInfo>,
}

public struct PositionRewardInfo has copy, drop, store {
    reward_growth_inside_last: u128,
    coins_owed_reward: u64,
}

fun init(dummy_position: POSITION, tx_context: &mut TxContext) {
    let claimed_position = package::claim<POSITION>(dummy_position, tx_context);
    let mut display = display::new<Position>(&claimed_position, tx_context);
    display::add<Position>(
        &mut display,
        string::utf8(b"name"),
        string::utf8(constants::position_display_name()),
    );
    display::add<Position>(
        &mut display,
        string::utf8(b"description"),
        string::utf8(constants::position_display_description()),
    );
    display::add<Position>(
        &mut display,
        string::utf8(b"image_url"),
        string::utf8(constants::position_display_image_url()),
    );
    display::update_version<Position>(&mut display);
    transfer::public_transfer<display::Display<Position>>(display, tx_context::sender(tx_context));
    transfer::public_transfer<package::Publisher>(claimed_position, tx_context::sender(tx_context));
}

// --- Public Functions ---
public fun coins_owed_reward(position: &Position, reward_index: u64): u64 {
    if (reward_index >= vector::length<PositionRewardInfo>(&position.reward_infos)) {
        0
    } else {
        vector::borrow<PositionRewardInfo>(&position.reward_infos, reward_index).coins_owed_reward
    }
}

// returns if position does not have claimable rewards.
public fun is_empty(position: &Position): bool {
    let mut is_empty_rewards = true;
    let mut index = 0;
    while (index < vector::length<PositionRewardInfo>(&position.reward_infos)) {
        if (
            vector::borrow<PositionRewardInfo>(&position.reward_infos, index).coins_owed_reward != 0
        ) {
            is_empty_rewards = false;
            break
        };
        index = index + 1;
    };
    let is_empty_position =
        position.liquidity == 0 && position.owed_coin_x == 0 && position.owed_coin_y == 0;
    is_empty_position && is_empty_rewards
}

public fun reward_growth_inside_last(position: &Position, reward_index: u64): u128 {
    if (reward_index >= vector::length<PositionRewardInfo>(&position.reward_infos)) {
        0
    } else {
        vector::borrow<PositionRewardInfo>(
            &position.reward_infos,
            reward_index,
        ).reward_growth_inside_last
    }
}

// public getter functions
public fun reward_length(position: &Position): u64 {
    vector::length<PositionRewardInfo>(&position.reward_infos)
}

public fun tick_lower_index(position: &Position): I32 { position.tick_lower_index }

public fun tick_upper_index(position: &Position): I32 { position.tick_upper_index }

public fun liquidity(position: &Position): u128 { position.liquidity }

public fun owed_coin_x(position: &Position): u64 { position.owed_coin_x }

public fun owed_coin_y(position: &Position): u64 { position.owed_coin_y }

public fun fee_growth_inside_x_last(position: &Position): u128 { position.fee_growth_inside_x_last }

public fun fee_growth_inside_y_last(position: &Position): u128 { position.fee_growth_inside_y_last }

public fun fee_rate(position: &Position): u64 { position.fee_rate }

public fun pool_id(position: &Position): ID { position.pool_id }

// --- Friend functions ---

// update position with d_l, fee & rewards.
public(package) fun update(
    position: &mut Position,
    liquidity_delta: I128,
    fee_growth_inside_x: u128,
    fee_growth_inside_y: u128,
    reward_growth_inside: vector<u128>,
) {
    let updated_liquidity = if (mmt_v3::i128::eq(liquidity_delta, mmt_v3::i128::zero())) {
        assert!(position.liquidity > 0, error::insufficient_liquidity());
        position.liquidity
    } else {
        mmt_v3::liquidity_math::add_delta(position.liquidity, liquidity_delta)
    };
    // fee_x = (fee_growth_inside_x - position.fee_growth_inside_x_last) / position.liquidity
    let fee_growth_delta_x = mmt_v3::full_math_u128::mul_div_floor(
        mmt_v3::math_u128::wrapping_sub(fee_growth_inside_x, position.fee_growth_inside_x_last),
        position.liquidity,
        mmt_v3::constants::q64(),
    );
    let fee_growth_delta_y = mmt_v3::full_math_u128::mul_div_floor(
        mmt_v3::math_u128::wrapping_sub(fee_growth_inside_y, position.fee_growth_inside_y_last),
        position.liquidity,
        mmt_v3::constants::q64(),
    );

    assert!(
        fee_growth_delta_x <= (mmt_v3::constants::max_u64() as u128) && 
            fee_growth_delta_y <= (mmt_v3::constants::max_u64() as u128),
        error::invalid_fee_growth(),
    );

    assert!(
        mmt_v3::math_u64::add_check(position.owed_coin_x, fee_growth_delta_x as u64) &&
            mmt_v3::math_u64::add_check(position.owed_coin_y, fee_growth_delta_y as u64),
        error::add_check_failed(),
    );

    update_reward_infos(position, reward_growth_inside);

    position.liquidity = updated_liquidity;
    position.fee_growth_inside_x_last = fee_growth_inside_x;
    position.fee_growth_inside_y_last = fee_growth_inside_y;
    position.owed_coin_x = position.owed_coin_x + (fee_growth_delta_x as u64);
    position.owed_coin_y = position.owed_coin_y + (fee_growth_delta_y as u64);
}

// creates a new position object.
public(package) fun open(
    pool_id: ID,
    fee_rate: u64,
    type_x: TypeName,
    type_y: TypeName,
    tick_lower_index: I32,
    tick_upper_index: I32,
    tx_context: &mut TxContext,
): Position {
    Position {
        id: object::new(tx_context),
        pool_id: pool_id,
        fee_rate: fee_rate,
        type_x: type_x,
        type_y: type_y,
        tick_lower_index: tick_lower_index,
        tick_upper_index: tick_upper_index,
        liquidity: 0,
        fee_growth_inside_x_last: 0,
        fee_growth_inside_y_last: 0,
        owed_coin_x: 0,
        owed_coin_y: 0,
        reward_infos: vector::empty<PositionRewardInfo>(),
    }
}

// destroys position object
public(package) fun close(position: Position) {
    let Position {
        id: position_id,
        pool_id: _,
        fee_rate: _,
        type_x: _,
        type_y: _,
        tick_lower_index: _,
        tick_upper_index: _,
        liquidity: _,
        fee_growth_inside_x_last: _,
        fee_growth_inside_y_last: _,
        owed_coin_x: _,
        owed_coin_y: _,
        reward_infos: _,
    } = position;
    object::delete(position_id);
}

public(package) fun decrease_owed_amount(position: &mut Position, amount_x: u64, amount_y: u64) {
    position.owed_coin_x = position.owed_coin_x - amount_x;
    position.owed_coin_y = position.owed_coin_y - amount_y;
}

public(package) fun decrease_reward_debt(position: &mut Position, reward_index: u64, amount: u64) {
    let reward_info = try_borrow_mut_reward_info(position, reward_index);
    reward_info.coins_owed_reward = reward_info.coins_owed_reward - amount;
}

public(package) fun increase_owed_amount(position: &mut Position, amount_x: u64, amount_y: u64) {
    position.owed_coin_x = position.owed_coin_x + amount_x;
    position.owed_coin_y = position.owed_coin_y + amount_y;
}

// --- Private functions ---

fun try_borrow_mut_reward_info(
    position: &mut Position,
    reward_index: u64,
): &mut PositionRewardInfo {
    if (reward_index >= vector::length<PositionRewardInfo>(&position.reward_infos)) {
        let new_reward_info = PositionRewardInfo {
            reward_growth_inside_last: 0,
            coins_owed_reward: 0,
        };
        vector::push_back<PositionRewardInfo>(&mut position.reward_infos, new_reward_info);
    };
    vector::borrow_mut<PositionRewardInfo>(&mut position.reward_infos, reward_index)
}

fun update_reward_infos(position: &mut Position, reward_growth_inside: vector<u128>) {
    let mut index = 0;
    let position_liquidity = position.liquidity;
    while (index < vector::length<u128>(&reward_growth_inside)) {
        let growth = *vector::borrow<u128>(&reward_growth_inside, index);
        let reward_info = try_borrow_mut_reward_info(position, index);
        let reward_delta = mmt_v3::full_math_u128::mul_div_floor(
            mmt_v3::math_u128::wrapping_sub(growth, reward_info.reward_growth_inside_last),
            position_liquidity,
            mmt_v3::constants::q64(),
        );

        assert!(
            reward_delta <= (mmt_v3::constants::max_u64() as u128) &&
                mmt_v3::math_u64::add_check(reward_info.coins_owed_reward, reward_delta as u64),
            error::update_rewards_info_check_failed(),
        );

        reward_info.reward_growth_inside_last = growth;
        reward_info.coins_owed_reward = reward_info.coins_owed_reward + (reward_delta as u64);
        index = index + 1;
    };
}
