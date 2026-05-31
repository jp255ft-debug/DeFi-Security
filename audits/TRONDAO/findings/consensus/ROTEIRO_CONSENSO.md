# 🎯 Roteiro de Análise — Consenso TRON (java-tron)

> **Alvo:** TRON DAO (HackerOne — US$ 100.000)
> **Componente:** `consensus/` no repositório java-tron
> **Prioridade:** 🔴 MÁXIMA (US$ 100.000)

---

## 📂 Estrutura Relevante no Repositório

```
consensus/
├── pbft/              # Algoritmo PBFT (Practical Byzantine Fault Tolerance)
│   ├── PbftManager.java
│   ├── PbftMessageHandler.java
│   └── ...
├── base/              # Estruturas base de consenso
│   ├── BlockHandle.java
│   └── ConsensusInterface.java
└── ...
```

---

## 🔬 Vetor 1: Bypass de Validação de Blocos (US$ 100.000)

### O Que Procurar

O TRON usa **DPoS + PBFT**. A validação de blocos ocorre em múltiplas camadas:

| Camada | Arquivo Alvo | O Que Verificar |
|:-------|:-------------|:----------------|
| **Assinatura do Bloco** | `BlockValidate.java` | Verificação de assinatura do SR (Super Representative) |
| **Merkle Root** | `BlockMerkleValidate.java` | Validação da raiz Merkle das transações |
| **Timestamp** | `BlockTimeValidate.java` | Verificação de timestamps (futuro/passado) |
| **Parent Hash** | `BlockParentHashValidate.java` | Encadeamento correto com bloco anterior |
| **PBFT** | `PbftManager.java` | Validação de mensagens PBFT (assinaturas, sequência) |

### Checklist de Verificação

- [ ] A assinatura do bloco é verificada **antes** de processar as transações?
- [ ] Existe alguma condição onde um bloco com assinatura inválida é aceito?
- [ ] A validação de Merkle root pode ser bypassada com transações vazias?
- [ ] O timestamp permite valores extremos (ex: ano 1970 ou 3000)?
- [ ] O parent hash pode ser manipulado para criar forks inválidos?
- [ ] Mensagens PBFT são validadas com nonce/sequência para evitar replay?

### Código Suspeito (Padrões a Buscar)

```java
// PADRÃO PERIGOSO: validação condicional que pode ser ignorada
if (block.getSignature() != null && !block.getSignature().isEmpty()) {
    // valida assinatura
}

// PADRÃO PERIGOSO: exceção genérica que pode engolir erros
try {
    validateBlock(block);
} catch (Exception e) {
    // log e continua — BLOCO INVÁLIDO PODE SER ACEITO
}

// PADRÃO PERIGOSO: validação apenas em certos tipos de bloco
if (blockType == BLOCK_TYPE_NORMAL) {
    validateSignature(block);
}
// BLOCOS DE TESTE/GENESIS PODEM PASSAR SEM VALIDAÇÃO
```

---

## 🔬 Vetor 2: Ataque de Longa Distância (Long Range Attack)

### O Que Procurar

Em DPoS, um atacante pode tentar criar uma chain alternativa a partir de um checkpoint antigo.

| Arquivo Alvo | O Que Verificar |
|:-------------|:----------------|
| `ForkController.java` | Lógica de fork choice (qual chain é a correta) |
| `BlockStorage.java` | Armazenamento de blocos e checkpoints |
| `SolidityBlock.java` | Blocos "solidificados" (irreversíveis) |

### Checklist de Verificação

- [ ] Existe um checkpoint de irreversibilidade (solidified block)?
- [ ] O fork choice considera o trabalho acumulado ou apenas altura?
- [ ] Blocos antigos podem ser reorgados sem limite de profundidade?
- [ ] O número de testemunhas (SRs) para finalizar um bloco é seguro?

---

## 🔬 Vetor 3: Manipulação de SR (Super Representative)

### O Que Procurar

O TRON tem 27 SRs que produzem blocos em rodízio.

| Arquivo Alvo | O Que Verificar |
|:-------------|:----------------|
| `SrManager.java` | Gerenciamento da lista de SRs |
| `VoteController.java` | Sistema de votação para eleger SRs |
| `WitnessController.java` | Controle de testemunhas |

### Checklist de Verificação

- [ ] Um SR pode produzir blocos fora de seu turno?
- [ ] A votação pode ser manipulada para eleger um SR malicioso?
- [ ] Existe proteção contra Sybil attack no registro de SRs?
- [ ] Um SR pode produzir múltiplos blocos no mesmo slot?

---

## 🔬 Vetor 4: PBFT Message Forgery

### O Que Procurar

O PBFT do TRON usa mensagens entre SRs para chegar a consenso.

| Arquivo Alvo | O Que Verificar |
|:-------------|:----------------|
| `PbftMessageHandler.java` | Manipulação de mensagens PBFT |
| `PbftManager.java` | Gerenciamento do estado PBFT |

### Checklist de Verificação

- [ ] Mensagens PBFT são assinadas individualmente?
- [ ] O nonce/sequência previne replay attacks?
- [ ] Um SR pode enviar mensagens PBFT falsas para finalizar blocos inválidos?
- [ ] Existe verificação de que o remetente é um SR legítimo?

---

## 📝 Template de Finding

Para cada vulnerabilidade encontrada, crie um arquivo em:
```
audits/TRONDAO/findings/consensus/F-XXX_NOME_DO_BUG.md
```

Use o formato:

```markdown
# F-XXX: [Título do Bug]

**Componente:** `consensus/pbft/PbftManager.java`
**Severidade:** Crítica / Alta / Média
**Recompensa Estimada:** US$ X.XXX

## Descrição
[Descrição detalhada do bug]

## Passos para Reproduzir
1. [Passo 1]
2. [Passo 2]
3. [Passo 3]

## Impacto
[Impacto quantificado]

## Código Vulnerável
```java
// Código relevante
```

## Correção Proposta
```java
// Código corrigido
```
```

---

## 📊 Priorização

| Ordem | Vetor | Esforço | Recompensa | ROI |
|:-----:|:------|:-------:|:----------:|:---:|
| 1 | Bypass de validação de blocos | 2h | US$ 100.000 | 🔥 |
| 2 | PBFT Message Forgery | 2h | US$ 50.000+ | 🔥 |
| 3 | Long Range Attack | 1h | US$ 25.000 | ⚡ |
| 4 | Manipulação de SR | 1h | US$ 10.000 | ⚡ |

---

> **Iniciar análise em:** `consensus/pbft/PbftManager.java` — é onde estão os bugs de maior valor.
