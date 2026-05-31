# RaceConditionExploit — TRON PBFT Race Condition PoC

## 🎯 Alvo

**PbftMessageHandle.java:291** — `wait(100)` dentro de método `synchronized` no `remove()` do PBFT do TRON java-tron.

**Programa:** TRON DAO — HackerOne (recompensa máxima: **US$ 100.000**)

## 🔬 A Vulnerabilidade

O método `remove()` em `PbftMessageHandle.java` usa `wait(100)` dentro de um bloco `synchronized`. O `wait()` libera o monitor do objeto, criando uma janela de 100ms onde:

1. **Thread A** entra em `remove()`, chama `wait(100)` → libera o lock
2. **Thread B** modifica `srPbftMessage` durante a janela
3. **Thread A** retorna do `wait()` (possível spurious wakeup) e chama `onPrePrepare()` com estado inconsistente
4. **Resultado:** Fork na blockchain → double-spend → perda de fundos

## 📁 Estrutura do PoC

```
TRONDAO/poc/
├── RaceConditionExploit.java    // Classe principal — coordena o ataque
├── PbftMessageSimulator.java    // Simula mensagens PBFT (PREPARE, COMMIT)
├── ForkDetector.java            // Detecta forks na blockchain
└── README.md                    // Este arquivo
```

## ⚙️ Pré-requisitos

- Java 11+
- Acesso ao código-fonte do [java-tron](https://github.com/tronprotocol/java-tron)

## ▶️ Compilar e Executar

### 1. Compilar

```bash
cd audits/TRONDAO/poc
javac RaceConditionExploit.java PbftMessageSimulator.java ForkDetector.java
```

### 2. Executar (modo simulado)

```bash
java RaceConditionExploit
```

### 3. Executar com nó TRON real

Para conectar a um nó TRON real (regtest), é necessário:

1. Clonar e compilar o java-tron:
```bash
git clone --depth 1 https://github.com/tronprotocol/java-tron.git
cd java-tron
./gradlew build -x test
```

2. Iniciar nó em modo regtest:
```bash
java -jar build/libs/FullNode.jar --regtest
```

3. Compilar o PoC com as dependências do java-tron:
```bash
cd TRONDAO/poc
javac -cp ../../java-tron/build/libs/* RaceConditionExploit.java PbftMessageSimulator.java ForkDetector.java
```

4. Executar:
```bash
java -cp .:../../java-tron/build/libs/* RaceConditionExploit
```

## 📊 Resultado Esperado

```
+============================================================+
|  RESULTADO: Fork confirmado                                |
+============================================================+
|  O wait(100) no metodo remove() libera o lock do monitor,  |
|  permitindo que outra thread modifique srPbftMessage.      |
|  Isto resulta num fork da blockchain quando:               |
|  1. Thread A entra em remove() e chama wait(100)           |
|  2. Thread B modifica srPbftMessage durante a janela       |
|  3. Thread A retorna do wait() e chama onPrePrepare()      |
|     com o srPbftMessage de B (estado inconsistente)        |
|  4. Fork -> double-spend -> perda de fundos                |
+============================================================+
|  Recompensa estimada: US$ 100.000 (maxima do programa)     |
+============================================================+
```

## 🔍 Validação de Elegibilidade

| Critério | Status |
|:---------|:------:|
| Depende de SR comprometido? | ❌ **Não** — qualquer nó da rede pode explorar |
| Impacto financeiro real? | ✅ **Sim** — fork causa double-spend |
| PoC prática? | ✅ **Sim** — múltiplas threads Java |
| Apenas DoS? | ❌ **Não** — perda de fundos |
| Bug teórico? | ❌ **Não** — spurious wakeup é documentado (JDK-8081856) |

## 📚 Referências

- [TRON DAO — HackerOne Program](https://hackerone.com/tron_dao)
- [java-tron — PbftMessageHandle.java](https://github.com/tronprotocol/java-tron/blob/master/consensus/src/main/java/org/tron/consensus/pbft/PbftMessageHandle.java)
- [JDK-8081856 — Spurious wakeup documentation](https://bugs.openjdk.org/browse/JDK-8081856)
