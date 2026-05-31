module mmt_v3::tick_bitmap;

use mmt_v3::error;
use mmt_v3::i32::I32;
use sui::table::{Self, Table};

// --- Public Functions ---

public fun cast_to_u8(value: I32): u8 {
    assert!(mmt_v3::i32::abs_u32(value) < 256, error::value_out_of_range());
    (mmt_v3::i32::abs_u32(mmt_v3::i32::add(value, mmt_v3::i32::from(256))) & 255) as u8
}

public fun next_initialized_tick_within_one_word(
    tick_table: &Table<I32, u256>,
    start_tick: I32,
    tick_spacing: u32,
    search_direction: bool,
): (I32, bool) {
    let spacing_i32 = mmt_v3::i32::from(tick_spacing);
    let word_index = mmt_v3::i32::div(start_tick, spacing_i32);
    let mut search_word_index = word_index;

    if (
        mmt_v3::i32::is_neg(start_tick) && 
            mmt_v3::i32::abs_u32(start_tick) % tick_spacing != 0
    ) {
        search_word_index = mmt_v3::i32::sub(word_index, mmt_v3::i32::from(1));
    };

    if (search_direction) {
        let (word_pos, bit_pos) = position(search_word_index);
        let tick_word =
            try_get_tick_word(tick_table, word_pos) & ((1u256 << bit_pos) - 1 + (1u256 << bit_pos));
        let initialized = tick_word != 0;
        let next_tick = if (tick_word != 0) {
            mmt_v3::i32::mul(
                mmt_v3::i32::sub(
                    search_word_index,
                    mmt_v3::i32::sub(
                        mmt_v3::i32::from(bit_pos as u32),
                        mmt_v3::i32::from(mmt_v3::bit_math::most_significant_bit(tick_word) as u32),
                    ),
                ),
                spacing_i32,
            )
        } else {
            mmt_v3::i32::mul(
                mmt_v3::i32::sub(search_word_index, mmt_v3::i32::from(bit_pos as u32)),
                spacing_i32,
            )
        };
        (next_tick, initialized)
    } else {
        let (word_pos, bit_pos) = position(
            mmt_v3::i32::add(search_word_index, mmt_v3::i32::from(1)),
        );
        let tick_word =
            try_get_tick_word(tick_table, word_pos) & ((1u256 << bit_pos) - 1 ^ mmt_v3::constants::max_u256());
        let initialized = tick_word != 0;
        let next_tick = if (tick_word != 0) {
            mmt_v3::i32::mul(
                mmt_v3::i32::add(
                    mmt_v3::i32::add(search_word_index, mmt_v3::i32::from(1)),
                    mmt_v3::i32::from(
                        (mmt_v3::bit_math::least_significant_bit(tick_word) as u32) - (bit_pos as u32),
                    ),
                ),
                spacing_i32,
            )
        } else {
            mmt_v3::i32::mul(
                mmt_v3::i32::add(
                    mmt_v3::i32::add(search_word_index, mmt_v3::i32::from(1)),
                    mmt_v3::i32::from((mmt_v3::constants::max_u8() as u32) - (bit_pos as u32)),
                ),
                spacing_i32,
            )
        };
        (next_tick, initialized)
    }
}

// --- Friend functions ---

public(package) fun flip_tick(
    tick_table: &mut Table<I32, u256>,
    tick_index: I32,
    tick_spacing: u32,
) {
    assert!(mmt_v3::i32::abs_u32(tick_index) % tick_spacing == 0, error::invalid_tick());
    let (word_index, bit_pos) = position(
        mmt_v3::i32::div(tick_index, mmt_v3::i32::from(tick_spacing)),
    );
    let tick_word = try_borrow_mut_tick_word(tick_table, word_index);
    *tick_word = *tick_word ^ (1u256 << bit_pos);
}

// --- Private functions ---

fun position(tick_index: I32): (I32, u8) {
    (
        mmt_v3::i32::shr(tick_index, 8),
        cast_to_u8(
            mmt_v3::i32::mod(
                tick_index,
                mmt_v3::i32::from(256),
            ),
        ),
    )
}

fun try_borrow_mut_tick_word(tick_table: &mut Table<I32, u256>, word_index: I32): &mut u256 {
    if (!table::contains<I32, u256>(tick_table, word_index)) {
        table::add<I32, u256>(tick_table, word_index, 0);
    };
    table::borrow_mut<I32, u256>(tick_table, word_index)
}

fun try_get_tick_word(tick_table: &Table<I32, u256>, word_index: I32): u256 {
    if (!table::contains<I32, u256>(tick_table, word_index)) {
        0
    } else {
        *table::borrow<I32, u256>(tick_table, word_index)
    }
}
