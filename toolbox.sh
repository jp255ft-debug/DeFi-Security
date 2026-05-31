#!/bin/bash
# ============================================================
# toolbox.sh — Atalho para o eth-security-toolbox
# 
# Inicia o container padronizado da Trail of Bits com o
# workspace montado em /home/auditor
#
# Uso: ./toolbox.sh
# ============================================================
docker run -it --rm \
  -v "$(pwd)":/home/auditor \
  ghcr.io/trailofbits/eth-security-toolbox:nightly
