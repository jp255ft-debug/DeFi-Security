# Analise Automatizada de Seguranca - Momentum DEX (Move/Sui) - v3

> Gerado em: 2026-05-04T15:05:40.834846

## Resumo

| Severidade | Quantidade |
|------------|-----------|
| Critical | 0 |
| High | 4 |
| Medium | 6 |
| Low | 0 |
| Info | 0 |

**Total de achados: 10**

### High

**storage\pool.move:133**
- **Tipo:** dynamic_field_key_collision
- **Descricao:** Adicao de dynamic_field - verificar se a chave pode colidir
- **Match:** `dynamic_field::add<MinTickRangeDfKey, u32>(
        &mut pool.id,`
```move

    let min_tick_range_key = MinTickRangeDfKey {};
    dynamic_field::add<MinTickRangeDfKey, u32>(
        &mut pool.id,
        min_tick_range_key,
```

**storage\pool.move:838**
- **Tipo:** unchecked_reward_manipulation
- **Descricao:** Atualizacao direta de parametros de recompensa - possivel manipulacao
- **Match:** `reward_info.total_reward =`
```move
    assert!(new_end_time > reward_info.last_update_time, error::invalid_last_update_time());

    reward_info.total_reward = reward_info.total_reward + balance::value<R>(&additional_balance);
    reward_info.ended_at_seconds = new_end_time;
    reward_info.reward_per_seconds =
```

**storage\pool.move:839**
- **Tipo:** unchecked_reward_manipulation
- **Descricao:** Atualizacao direta de parametros de recompensa - possivel manipulacao
- **Match:** `reward_info.ended_at_seconds =`
```move

    reward_info.total_reward = reward_info.total_reward + balance::value<R>(&additional_balance);
    reward_info.ended_at_seconds = new_end_time;
    reward_info.reward_per_seconds =
        full_math_u128::mul_div_floor(
```

**storage\pool.move:840**
- **Tipo:** unchecked_reward_manipulation
- **Descricao:** Atualizacao direta de parametros de recompensa - possivel manipulacao
- **Match:** `reward_info.reward_per_seconds =`
```move
    reward_info.total_reward = reward_info.total_reward + balance::value<R>(&additional_balance);
    reward_info.ended_at_seconds = new_end_time;
    reward_info.reward_per_seconds =
        full_math_u128::mul_div_floor(
            (reward_info.total_reward - reward_info.total_reward_allocated) as u128,
```

### Medium

**actions\trade.move:425**
- **Tipo:** unchecked_flash_loan_amount
- **Descricao:** Verificacao de flash loan usa < em vez de <= - possivel precisao
- **Match:** `amount_x < reserve_x`
```move

    let (reserve_x, reserve_y) = pool::get_reserves(pool);
    assert!((amount_x < reserve_x) && (amount_y < reserve_y), error::insufficient_funds());

    let flash_event = FlashLoanEvent {
```

**actions\trade.move:286**
- **Tipo:** missing_tick_validation
- **Descricao:** Calculo de tick a partir de sqrt_price sem validacao de limites
- **Match:** `tick_index = tick_math::get_tick_at_sqrt_price`
```move

        if (swap_state.sqrt_price != swap_step.sqrt_price_start) {
            swap_state.tick_index = tick_math::get_tick_at_sqrt_price(swap_state.sqrt_price);
            continue
        };
```

**actions\trade.move:729**
- **Tipo:** missing_tick_validation
- **Descricao:** Calculo de tick a partir de sqrt_price sem validacao de limites
- **Match:** `tick_index = tick_math::get_tick_at_sqrt_price`
```move

        if (swap_state.sqrt_price != swap_step.sqrt_price_start) {
            swap_state.tick_index = tick_math::get_tick_at_sqrt_price(swap_state.sqrt_price);
            continue
        };
```

**actions\trade.move:298**
- **Tipo:** oracle_manipulation
- **Descricao:** Escrita no oracle - verificar se ha protecao contra manipulacao via flash loans
- **Match:** `oracle::write(
            pool::observations_mut(pool)`
```move
        let observation_cardinality = pool::observation_cardinality(pool);
        let observation_cardinality_next = pool::observation_cardinality_next(pool);
        let (new_observation_index, new_observation_cardinality) = oracle::write(
            pool::observations_mut(pool),
            observation_index,
```

**storage\pool.move:122**
- **Tipo:** missing_tick_validation
- **Descricao:** Calculo de tick a partir de sqrt_price sem validacao de limites
- **Match:** `tick_index = tick_math::get_tick_at_sqrt_price`
```move
    assert!(pool.sqrt_price == 0, error::invalid_initialization());

    let tick_index = tick_math::get_tick_at_sqrt_price(sqrt_price);
    pool.tick_index = tick_index;
    pool.sqrt_price = sqrt_price;
```

**storage\pool.move:599**
- **Tipo:** oracle_manipulation
- **Descricao:** Escrita no oracle - verificar se ha protecao contra manipulacao via flash loans
- **Match:** `oracle::write(
            &mut pool.observations,
            pool.observation_index,
            utils::to_seconds(clo`
```move
    if (i32::gte(pool.tick_index, lower_tick_index) && i32::lt(pool.tick_index, upper_tick_index)) {
        // update oracle
        let (new_observation_index, new_observation_cardinality) = oracle::write(
            &mut pool.observations,
            pool.observation_index,
```

## Analise de Bibliotecas Matematicas

[OK] **integer-mate\full_math_u128.move**
- Wrapping: True, Checked: True, Casts: True

[OK] **integer-mate\full_math_u64.move**
- Wrapping: False, Checked: True, Casts: True

[OK] **integer-mate\math_u128.move**
- Wrapping: True, Checked: True, Casts: True

[OK] **integer-mate\math_u256.move**
- Wrapping: False, Checked: True, Casts: False

[OK] **integer-mate\math_u64.move**
- Wrapping: True, Checked: True, Casts: True

[WARN] **utils\bit_math.move**
- Wrapping: False, Checked: False, Casts: False

[OK] **utils\liquidity_math.move**
- Wrapping: False, Checked: True, Casts: True

[WARN] **utils\sqrt_price_math.move**
- Wrapping: False, Checked: False, Casts: True

[OK] **utils\swap_math.move**
- Wrapping: False, Checked: True, Casts: False

[WARN] **utils\tick_math.move**
- Wrapping: False, Checked: False, Casts: True

[OK] **tests\integer-mate\full_math_u128_test.move**
- Wrapping: True, Checked: True, Casts: False

[OK] **tests\integer-mate\full_math_u64_test.move**
- Wrapping: False, Checked: True, Casts: False

[OK] **tests\integer-mate\math_u128_test.move**
- Wrapping: True, Checked: True, Casts: False

[OK] **tests\integer-mate\math_u256_test.move**
- Wrapping: False, Checked: True, Casts: False

[OK] **tests\integer-mate\math_u64_test.move**
- Wrapping: True, Checked: True, Casts: False

[WARN] **tests\utils\liquidity_math_test.move**
- Wrapping: False, Checked: False, Casts: False

[WARN] **tests\utils\sqrt_price_math_test.move**
- Wrapping: False, Checked: False, Casts: False

[WARN] **integer-mate\integer_error.move**
- Wrapping: False, Checked: False, Casts: False

## Analise do Oracle
- [WARN] Oracle tem cardinalidade configuravel - verificar se ha limite minimo seguro (Severidade: Medium)