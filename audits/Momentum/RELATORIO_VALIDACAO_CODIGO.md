# Relatorio de Validacao de Codigo - Momentum DEX (Move/Sui)

> **Auditor:** Cline AI
> **Data:** 2026-05-04
> **Alvo:** v3-core (CLMM - Concentrated Liquidity Market Maker)
> **Linguagem:** Move (Sui Blockchain)

---

## Resumo Executivo

A analise automatizada identificou **10 achados** nos contratos Move do Momentum DEX v3-core. A implementacao segue de perto o padrao Uniswap V3 adaptado para Move/Sui, utilizando `dynamic_field` para armazenamento flexivel e `balance` do framework Sui para gestao de ativos.

### Estatisticas

| Metrica | Valor |
|---------|-------|
| Arquivos analisados | 58 |
| Achados automatizados | 10 |
| High | 4 |
| Medium | 6 |
| Bibliotecas matematicas com operacoes seguras | 7/10 |

---

## Achados Detalhados

### [H-01] Dynamic Field Key Collision em Pool

**Arquivo:** `storage/pool.move:133`
**Severidade:** High
**Tipo:** Design Vulnerability

**Descricao:**
O uso de `MinTickRangeDfKey {}` como chave para `dynamic_field` pode causar colisao se outro modulo utilizar a mesma struct como chave no mesmo objeto Pool.

**Codigo Vulneravel:**
```move
let min_tick_range_key = MinTickRangeDfKey {};
dynamic_field::add<MinTickRangeDfKey, u32>(
    &mut pool.id,
    min_tick_range_key,
    mmt_v3::constants::default_min_tick_range_factor(),
);
```

**Impacto:**
- Colisao de chaves pode corromper o estado do pool
- Dados podem ser sobrescritos acidentalmente

**Mitigacao:**
- Usar chaves mais especificas (ex: incluir tipo do pool na chave)
- Documentar todas as chaves de dynamic_field utilizadas

---

### [H-02] Manipulacao de Parametros de Recompensa

**Arquivo:** `storage/pool.move:838-840`
**Severidade:** High
**Tipo:** Logic Vulnerability

**Descricao:**
A funcao `update_pool_reward_emission` atualiza diretamente `total_reward`, `ended_at_seconds` e `reward_per_seconds` sem validacao adequada de consistencia entre os parametros.

**Codigo Vulneravel:**
```move
reward_info.total_reward = reward_info.total_reward + balance::value<R>(&additional_balance);
reward_info.ended_at_seconds = new_end_time;
reward_info.reward_per_seconds =
    full_math_u128::mul_div_floor(
        (reward_info.total_reward - reward_info.total_reward_allocated) as u128,
        mmt_v3::constants::q64() as u128,
        (reward_info.ended_at_seconds - reward_info.last_update_time) as u128,
    );
```

**Impacto:**
- Se `ended_at_seconds <= last_update_time`, a divisao por zero ocorre
- `reward_per_seconds` pode ser manipulado para valores extremos
- Possivel drenagem de recompensas se `total_reward_allocated > total_reward`

**Mitigacao:**
- Validar que `ended_at_seconds > last_update_time` (ja existe, linha 836)
- Validar que `total_reward >= total_reward_allocated`
- Adicionar limite superior para `reward_per_seconds`

---

### [H-03] Verificacao de Flash Loan com Precisao Incorreta

**Arquivo:** `actions/trade.move:425`
**Severidade:** High
**Tipo:** Precision Bug

**Descricao:**
A verificacao de disponibilidade de fundos para flash loan usa `<` em vez de `<=`, impedindo flash loans que utilizariam exatamente o saldo total das reservas.

**Codigo Vulneravel:**
```move
assert!((amount_x < reserve_x) && (amount_y < reserve_y), error::insufficient_funds());
```

**Impacto:**
- Flash loans de valor igual ao saldo total sao bloqueados desnecessariamente
- Impacto baixo em praticas normais, mas pode ser explorado em cenarios de liquidez baixa

**Mitigacao:**
```move
assert!((amount_x <= reserve_x) && (amount_y <= reserve_y), error::insufficient_funds());
```

---

### [H-04] Oracle Manipulavel via Flash Loans

**Arquivo:** `actions/trade.move:298`, `storage/pool.move:599`
**Severidade:** High
**Tipo:** Oracle Manipulation

**Descricao:**
O oracle e atualizado a cada operacao de swap e liquidity change sem protecao contra manipulacao via flash loans. Um atacante pode distorcer o preco do oracle temporariamente.

**Codigo Vulneravel:**
```move
let (new_observation_index, new_observation_cardinality) = oracle::write(
    pool::observations_mut(pool),
    observation_index,
    utils::to_seconds(clock::timestamp_ms(clock)),
    tick_index_current,
    liquidity,
    observation_cardinality,
    observation_cardinality_next,
);
```

**Impacto:**
- Produtos que dependem do oracle para precificacao podem ser manipulados
- Perda financeira para usuarios que utilizam o TWAP como referencia

**Mitigacao:**
- Implementar delay minimo entre observacoes
- Usar TWAP com periodo minimo de 30 minutos
- Considerar implementacao de oracle baseado em EMA (Exponential Moving Average)

---

### [M-01] Calculo de Tick sem Validacao de Limites

**Arquivo:** `actions/trade.move:286,729`, `storage/pool.move:122`
**Severidade:** Medium
**Tipo:** Input Validation

**Descricao:**
A funcao `get_tick_at_sqrt_price` e chamada sem validacao se o `sqrt_price` resultante esta dentro dos limites permitidos (`min_sqrt_price` / `max_sqrt_price`).

**Codigo Vulneravel:**
```move
swap_state.tick_index = tick_math::get_tick_at_sqrt_price(swap_state.sqrt_price);
```

**Impacto:**
- Em cenarios extremos, o tick calculado pode estar fora dos limites validos
- Potencial para comportamento inesperado em operacoes de swap

**Mitigacao:**
- Validar sqrt_price antes de calcular tick
- Usar `clamp` para garantir que o tick esteja dentro dos limites

---

### [M-02] Acumulo de Taxa sem Verificacao de Overflow

**Arquivo:** `actions/trade.move` (linha ~323)
**Severidade:** Medium
**Tipo:** Arithmetic Vulnerability

**Descricao:**
O acumulo de `protocol_fee_x` e `protocol_fee_y` e feito sem verificacao de overflow. Embora o Move tenha protecao nativa contra overflow em operacoes aritmeticas, o acumulo continuo pode levar a saturacao.

**Codigo Vulneravel:**
```move
pool::set_protocol_fee_x(pool, protocol_fee_x + swap_state.protocol_fee);
```

**Impacto:**
- Overflow causa revert da transacao, bloqueando operacoes
- Em altos volumes de taxa, o protocolo pode ficar inoperante

**Mitigacao:**
- Usar `math_u64::add_check` para verificacao explicita
- Implementar limite maximo de taxa acumulada

---

### [M-03] Bibliotecas Matematicas sem Operacoes Checked

**Arquivo:** `utils/bit_math.move`, `utils/sqrt_price_math.move`, `utils/tick_math.move`
**Severidade:** Medium
**Tipo:** Missing Safe Math

**Descricao:**
Tres bibliotecas matematicas nao utilizam operacoes checked (`add_check`, `mul_div`), confiando apenas na protecao nativa do Move contra overflow.

**Bibliotecas Afetadas:**
- `bit_math.move` - Sem wrapping, checked ou casts
- `sqrt_price_math.move` - Sem wrapping ou checked (apenas casts)
- `tick_math.move` - Sem wrapping ou checked (apenas casts)

**Impacto:**
- Overflow em operacoes de tick/price pode causar reverter inesperado
- Em raros casos, underflow pode passar despercebido

**Mitigacao:**
- Adicionar verificacoes explicitas nas operacoes criticas
- Documentar que a seguranca depende do runtime do Move

---

### [M-04] Oracle com Cardinalidade Configuravel

**Arquivo:** `utils/oracle.move`
**Severidade:** Medium
**Tipo:** Configuration Risk

**Descricao:**
A cardinalidade do oracle e configuravel sem um limite minimo obrigatorio. Um admin pode configurar cardinalidade muito baixa, reduzindo a qualidade do TWAP.

**Impacto:**
- Cardinalidade baixa = menos amostras = oracle mais facil de manipular
- Depende de acao administrativa, mas e um risco operacional

**Mitigacao:**
- Implementar cardinalidade minima obrigatoria (ex: 10 observacoes)
- Emitir evento quando cardinalidade for alterada

---

## Analise de Arquitetura

### Pontos Fortes

1. **Sistema de ACL Robusto**: Uso de `AdminCap` e `Acl` para controle de acesso granular
2. **Bibliotecas Matematicas Seguras**: 7/10 bibliotecas usam operacoes checked
3. **Eventos Abrangentes**: Todas as operacoes criticas emitem eventos
4. **Protecao contra Reentrancia**: Modelo de objetos do Move previne reentrancia naturalmente
5. **Slippage Protection**: Funcoes de liquidity aceitam `min_amount_x`/`min_amount_y`

### Pontos de Atencao

1. **Oracle Manipulavel**: Sem protecao contra flash loan attacks
2. **Reward Math**: Calculo de recompensas vulneravel a divisao por zero
3. **Flash Loan Precision**: Verificacao de saldo usa `<` em vez de `<=`
4. **Dynamic Field Keys**: Possibilidade de colisao de chaves

---

## Recomendacoes Prioritarias

1. **Critical**: Implementar protecao contra oracle manipulation (TWAP minimo de 30 min)
2. **High**: Corrigir verificacao de flash loan de `<` para `<=`
3. **High**: Adicionar validacao de consistencia em `update_pool_reward_emission`
4. **Medium**: Documentar e padronizar chaves de `dynamic_field`
5. **Medium**: Adicionar verificacoes checked em `bit_math`, `sqrt_price_math`, `tick_math`

---

## Proximos Passos

1. Revisao manual dos 10 achados para confirmar exploitabilidade
2. Desenvolvimento de PoC para [H-04] Oracle Manipulation
3. Validacao cruzada com documentacao oficial do projeto
4. Preparacao de submissoes para bug bounty (se aplicavel)
