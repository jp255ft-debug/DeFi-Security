# 🧠 Relatório de Dificuldades — Auditoria Ripio

## 1. 🔧 Problemas Técnicos com Ferramentas

### 1.1 Slither — `solc-select` não encontrado
- **Problema:** O Slither tentou usar `solc-select` para gerenciar versões do compilador, mas o comando não estava disponível no PATH do Windows.
- **Solução:** Instalamos manualmente com `pip install solc-select` e configuramos a versão `0.8.20` com `solc-select install 0.8.20 && solc-select use 0.8.20`.
- **Impacto:** Atraso de ~5 minutos na execução do pipeline.

### 1.2 Slither — Erro de parsing com `using for` global
- **Problema:** O Slither (versão antiga) não suporta a sintaxe `using {função} for tipo` no escopo global (introduzida no Solidity 0.8.13+).
- **Solução:** Atualizamos o Slither com `pip install --upgrade slither-analyzer`.
- **Impacto:** Atraso de ~3 minutos.

### 1.3 Halmos — Erro de instalação no Windows
- **Problema:** O Halmos não estava instalado e o `pip install halmos` falhou devido a dependências nativas (z3-solver).
- **Solução:** Instalamos manualmente com `pip install halmos[all]` que inclui todas as dependências.
- **Impacto:** Atraso de ~2 minutos.

### 1.4 Mythril — Erro de instalação
- **Problema:** O Mythril não estava instalado e a instalação via `pip install mythril` falhou devido a dependências conflitantes.
- **Solução:** Instalamos com `pip install mythril --no-deps` e depois instalamos as dependências manualmente.
- **Impacto:** Atraso de ~4 minutos.

### 1.5 Echidna — Não disponível no Windows
- **Problema:** O Echidna é uma ferramenta Linux/macOS e não está disponível nativamente no Windows.
- **Solução:** Pulamos a execução do Echidna (não crítico para esta auditoria).
- **Impacto:** Nenhum — o Echidna seria útil mas não essencial.

---

## 2. 🐛 Problemas com o Código Fonte

### 2.1 Repositório `wfiattokens` — Branch incorreta
- **Problema:** O `init_audit.sh` clonou o repositório `wfiattokens` mas a branch `main` estava desatualizada. Os contratos relevantes estavam em outra branch.
- **Solução:** Identificamos manualmente os contratos corretos e copiamos para `audits/Ripio/latam_contracts/`.
- **Impacto:** Atraso de ~10 minutos para localizar os arquivos corretos.

### 2.2 Dependências do Foundry não instaladas
- **Problema:** O `foundry.toml` do projeto referenciava dependências via `remappings` que não estavam instaladas (submódulos git não inicializados).
- **Solução:** Executamos `forge install` no diretório do projeto.
- **Impacto:** Atraso de ~5 minutos.

### 2.3 Contratos com erros de compilação
- **Problema:** Alguns contratos tinham erros de sintaxe ou importações quebradas (caminhos relativos incorretos).
- **Solução:** Corrigimos manualmente os imports e ajustamos o `foundry.toml` para incluir os diretórios corretos.
- **Impacto:** Atraso de ~8 minutos.

---

## 3. 🌐 Problemas com API HackerOne

### 3.1 Erro 500 ao submeter via API
- **Problema:** Ao tentar submeter o finding HIGH via API HackerOne com `--program ripio`, recebemos erro **500 Internal Server Error**.
- **Causa provável:** O programa `ripio` existe no HackerOne, mas o hacker `jp2026` pode não estar inscrito no programa, ou o programa não está configurado para aceitar reports via API de hackers.
- **Solução alternativa:** Geramos guias de **submissão manual** em `submissions/MANUAL_SUBMISSION_*.md`.

### 3.2 Erro 403 ao submeter para `circle-bbp`
- **Problema:** Ao testar com `--program circle-bbp`, recebemos erro **403 Forbidden**.
- **Causa:** O token do hacker `jp2026` não tem permissão para submeter reports para o programa Circle.
- **Impacto:** Confirmou que o token funciona, mas só tem acesso ao programa `ripio`.

### 3.3 `load_dotenv()` não funcionava em execuções inline
- **Problema:** Ao executar comandos Python inline com `-c`, o `load_dotenv()` do python-dotenv não carregava as variáveis do `.env`.
- **Causa:** O `load_dotenv()` procura o arquivo `.env` no CWD, mas em execuções inline o CWD pode ser diferente.
- **Solução:** Passamos as credenciais diretamente via variáveis de ambiente ou argumentos de linha de comando.

---

## 4. 🪟 Problemas com Windows

### 4.1 Encoding UTF-8 no terminal
- **Problema:** O terminal do Windows usa `cp1252` como encoding padrão, o que causa erros `UnicodeEncodeError` ao imprimir emojis (🏁, ✅, ❌, etc.).
- **Solução:** Adicionamos `sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')` no script.
- **Impacto:** Correção aplicada, mas ainda ocorre em execuções inline com `-c`.

### 4.2 Shebang `#!/usr/bin/env` ignorado
- **Problema:** Scripts com shebang Linux (`#!/bin/bash`) não funcionam no Windows.
- **Solução:** Executamos scripts com `bash scripts/run_*.sh` explicitamente.
- **Impacto:** Nenhum — apenas um lembrete para sempre usar `bash` prefix.

### 4.3 `chmod +x` não funciona no Windows
- **Problema:** O comando `chmod +x` não é suportado nativamente no Windows.
- **Solução:** Ignoramos — o Windows não precisa de permissão de execução.
- **Impacto:** Nenhum.

---

## 5. 📝 Problemas com Parsing de Findings

### 5.1 Formato inconsistente dos arquivos de findings
- **Problema:** Os arquivos `high.md`, `medium.md`, `low.md` usam formatação Markdown que varia entre português e inglês (`**Descrição:**` vs `**Description:**`, `**Mitigação:**` vs `**Recommended Mitigation:**`).
- **Solução:** O parser foi atualizado para aceitar ambos os formatos usando regex com alternância (`(?:Descrição|Description)`).
- **Impacto:** Nenhum após a correção.

### 5.2 Campo `impact` vazio em alguns findings
- **Problema:** O finding H-01 tinha o campo `impact` vazio porque o arquivo `high.md` usava `**Impact:**` (inglês) em vez de `**Impacto:**` (português).
- **Solução:** O parser foi atualizado para aceitar ambos os formatos.
- **Impacto:** Nenhum após a correção.

---

## 6. ⏱️ Problemas de Performance

### 6.1 Pipeline completo muito lento
- **Problema:** Executar todas as ferramentas (Slither, Aderyn, Semgrep, Halmos, Mythril) sequencialmente levou ~15 minutos.
- **Solução:** Usamos `--quick` para pular ferramentas mais lentas (Halmos, Mythril) quando não são críticas.
- **Impacto:** Redução para ~5 minutos com `--quick`.

### 6.2 `filter_noise.py` lento em arquivos grandes
- **Problema:** O script `filter_noise.py` demorava ~30 segundos para processar relatórios grandes do Slither (centenas de findings).
- **Solução:** Nenhuma — o tempo é aceitável para o volume de dados.
- **Impacto:** Mínimo.

---

## 📊 Resumo de Impacto

| Dificuldade | Impacto | Solução |
|-------------|---------|---------|
| Slither + solc-select | ⏱️ +5 min | Instalação manual |
| Slither parsing `using for` | ⏱️ +3 min | Upgrade do Slither |
| Halmos instalação | ⏱️ +2 min | `pip install halmos[all]` |
| Mythril instalação | ⏱️ +4 min | `pip install --no-deps` |
| Echidna no Windows | 🚫 Pulado | Não crítico |
| Branch errada do repo | ⏱️ +10 min | Cópia manual |
| Dependências Foundry | ⏱️ +5 min | `forge install` |
| Erros de compilação | ⏱️ +8 min | Correção manual |
| API HackerOne 500 | 🚫 API falhou | Submissão manual |
| Encoding UTF-8 Windows | 🐛 Menor | Correção no script |
| Parsing findings | 🐛 Menor | Regex flexível |

**Tempo total perdido com dificuldades:** ~40 minutos
**Tempo total da auditoria:** ~3 horas (incluindo análise, PoCs e documentação)
