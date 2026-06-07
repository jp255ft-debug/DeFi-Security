# ============================================================
# DeFi Security Workspace — Makefile
# ============================================================
# Uso:
#   make install          - Instala todas as dependências
#   make audit-quick      - Análise rápida (5-10 min)
#   make audit-full       - Análise completa (1-2h)
#   make validate-poc     - Valida PoCs (Foundry)
#   make depin-deploy     - Deploy contratos DePIN
# ============================================================

.PHONY: help install build test lint format clean

# ── Variáveis ───────────────────────────────────────────────
PYTHON := python3
PIP := pip3
PROJECT ?= LayerZero
MODE ?= --full

# ── Help (Default) ──────────────────────────────────────────
help:
	@echo "═══════════════════════════════════════════════════"
	@echo "  🛡️  DeFi Security Workspace"
	@echo "═══════════════════════════════════════════════════"
	@echo ""
	@echo "Comandos Disponíveis:"
	@echo ""
	@echo "  make install          - Instala dependências"
	@echo "  make build            - Compila contratos (Foundry)"
	@echo "  make test             - Executa testes"
	@echo "  make lint             - Lint Python + Solidity"
	@echo "  make format           - Formata código"
	@echo ""
	@echo "  make audit-quick      - Análise rápida (5-10 min)"
	@echo "  make audit-full       - Análise completa (1-2h)"
	@echo "  make audit-formal     - Verificação formal (horas)"
	@echo ""
	@echo "  make validate-poc     - Valida PoCs (12 checks)"
	@echo "  make depin-deploy     - Deploy contratos DePIN"
	@echo "  make depin-test       - Testa conectores DePIN"
	@echo ""
	@echo "  make clean            - Remove artefatos de build"
	@echo ""
	@echo "Exemplo:"
	@echo "  make audit-full PROJECT=Moonwell"
	@echo ""

# ── Instalação ──────────────────────────────────────────────
install:
	@echo "📦 Instalando dependências Python..."
	$(PIP) install -r requirements.txt
	@echo "📦 Instalando Foundry..."
	foundryup
	@echo "✅ Instalação concluída"

install-dev:
	$(PIP) install -r requirements.txt
	$(PIP) install -r requirements-dev.txt
	pre-commit install
	@echo "✅ Ambiente de desenvolvimento pronto"

# ── Build ───────────────────────────────────────────────────
build:
	@echo "🔨 Compilando contratos DePIN..."
	cd depin/contracts && forge build --sizes
	@echo "🔨 Compilando src/..."
	cd src && forge build --sizes
	@echo "✅ Build concluído"

build-poc:
	@echo "🔨 Compilando PoC: $(PROJECT)..."
	cd audits/$(PROJECT)/poc && forge build --sizes
	@echo "✅ PoC compilado"

# ── Testes ──────────────────────────────────────────────────
test:
	@echo "🧪 Executando testes DePIN..."
	cd depin/contracts && forge test -vvv
	@echo "🧪 Executando testes src/..."
	cd src && forge test -vvv
	@echo "✅ Testes concluídos"

test-poc:
	@echo "🧪 Testando PoC: $(PROJECT)..."
	cd audits/$(PROJECT)/poc && forge test -vvv
	@echo "✅ PoC testado"

test-coverage:
	cd depin/contracts && forge coverage
	cd src && forge coverage

# ── Lint & Format ───────────────────────────────────────────
lint:
	@echo "🔍 Linting Python..."
	flake8 scripts/ depin/connectors/
	mypy scripts/ depin/connectors/ --ignore-missing-imports
	@echo "🔍 Linting Solidity..."
	forge fmt --check
	@echo "✅ Lint concluído"

format:
	@echo "🎨 Formatando Python..."
	black scripts/ depin/connectors/
	isort scripts/ depin/connectors/
	@echo "🎨 Formatando Solidity..."
	forge fmt
	@echo "✅ Formatação concluída"

# ── Auditoria ───────────────────────────────────────────────
audit-quick:
	@echo "⚡ Iniciando audit rápido: $(PROJECT)..."
	bash scripts/run_pipeline.sh $(PROJECT) --quick

audit-full:
	@echo "🔍 Iniciando audit completo: $(PROJECT)..."
	bash scripts/run_pipeline.sh $(PROJECT) --full

audit-formal:
	@echo "🧬 Iniciando verificação formal: $(PROJECT)..."
	bash scripts/run_pipeline.sh $(PROJECT) --formal

# ── Validação de PoC ────────────────────────────────────────
validate-poc:
	@echo "✅ Validando PoC: $(PROJECT)..."
	$(PYTHON) scripts/validate_submission.py --poc-dir audits/$(PROJECT)/poc
	@echo "📋 Checklist manual:"
	@cat knowledge_base/checklists/poc_validation.md

# ── DePIN ───────────────────────────────────────────────────
depin-deploy:
	@echo "🚀 Deploy contratos DePIN..."
	bash scripts/deploy_verifier.sh

depin-test:
	@echo "🧪 Testando conectores DePIN..."
	$(PYTHON) depin/connectors/dimo_connector.py --dry-run
	$(PYTHON) depin/connectors/helium_ingest.py --dry-run
	$(PYTHON) depin/connectors/streamr_publisher.py --dry-run
	@echo "✅ Conectores testados"

depin-pipeline:
	bash scripts/run_depin_pipeline.sh

# ── Security ────────────────────────────────────────────────
security-scan:
	@echo "🔒 Escaneando secrets..."
	detect-secrets scan --baseline .secrets.baseline
	@echo "🔒 Escaneando vulnerabilidades Python..."
	safety check
	bandit -r scripts/ depin/connectors/
	@echo "✅ Security scan concluído"

# ── Clean ───────────────────────────────────────────────────
clean:
	@echo "🧹 Removendo artefatos..."
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete
	find . -type d -name "cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "out" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "artifacts" -exec rm -rf {} + 2>/dev/null || true
	@echo "✅ Limpeza concluída"

# ── Utility ─────────────────────────────────────────────────
init-audit:
	bash scripts/init_audit.sh $(PROJECT)

quantum-scan:
	$(PYTHON) scripts/quantum_risk_scanner.py $(PROJECT)

.DEFAULT_GOAL := help
