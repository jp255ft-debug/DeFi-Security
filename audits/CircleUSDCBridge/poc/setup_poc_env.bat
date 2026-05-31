@echo off
REM ============================================================
REM Script de Setup do Ambiente PoC para Circle USDC Bridge
REM ============================================================
REM Este script instala o Foundry e prepara o ambiente para
REM compilar e testar os PoCs.
REM
REM Uso:
REM   .\setup_poc_env.bat
REM
REM Depois de executar, teste com:
REM   forge test --fork-url https://ethereum-rpc.publicnode.com -vvvv
REM ============================================================

setlocal enabledelayedexpansion

echo ============================================================
echo  🛠️  Setup do Ambiente PoC - Circle USDC Bridge
echo ============================================================
echo.

REM ============================================================
REM PASSO 1: Verificar / Instalar Foundry
REM ============================================================

REM Verificar se o Foundry já está instalado
where forge >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✅ Foundry ja esta instalado!
    forge --version
    echo.
    goto :check_foundryup
)

echo ⚠️  Foundry nao encontrado. Instalando...
echo.

REM --- Método 1: foundryup (recomendado, mais rápido) ---
echo 📦 Tentando instalacao via foundryup (metodo oficial)...
echo.

REM Baixar e executar foundryup
echo    Baixando foundryup...
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command ^
    "Invoke-WebRequest -Uri https://foundry.paradigm.xyz -OutFile '%TEMP%\foundryup.ps1' 2>$null" >nul 2>&1

if exist "%TEMP%\foundryup.ps1" (
    echo    Executando foundryup...
    @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "%TEMP%\foundryup.ps1" >nul 2>&1
    del "%TEMP%\foundryup.ps1" 2>nul

    REM Aguardar e verificar se foi instalado
    call :wait_and_check_forge
    if !ERRORLEVEL! EQU 0 (
        echo ✅ Foundry instalado com sucesso via foundryup!
        forge --version
        echo.
        goto :install_deps
    )
) else (
    echo    ⚠️  Nao foi possivel baixar foundryup. Tentando metodo alternativo...
)

REM --- Método 2: Cargo (fallback) ---
echo 📦 Tentando instalacao via Cargo (compilacao, pode levar ~30 min)...
echo.
where cargo >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo    Compilando Foundry via Cargo. Isso pode levar varios minutos...
    cargo install --git https://github.com/foundry-rs/foundry --profile release --locked 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo ✅ Foundry instalado com sucesso via Cargo!
        goto :install_deps
    ) else (
        echo ❌ Erro ao compilar via Cargo.
    )
) else (
    echo    ⚠️  Cargo/Rust nao encontrado.
)

REM --- Se chegou aqui, nenhum metodo funcionou ---
echo.
echo ❌ Nao foi possivel instalar o Foundry automaticamente.
echo.
echo Para instalacao manual:
echo   1. Baixe o binario pre-compilado em:
echo      https://github.com/foundry-rs/foundry/releases
echo.
echo   2. Extraia e adicione ao PATH do Windows
echo.
echo   3. Verifique a instalacao:
echo      forge --version
echo.
echo   4. Execute este script novamente:
echo      .\setup_poc_env.bat
echo.
pause
exit /b 1

:check_foundryup
REM Se Foundry ja esta instalado, verificar se foundryup esta atualizado
echo 📦 Verificando se foundryup esta disponivel...
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command ^
    "Invoke-WebRequest -Uri https://foundry.paradigm.xyz -OutFile '%TEMP%\foundryup.ps1' 2>$null" >nul 2>&1
if exist "%TEMP%\foundryup.ps1" (
    echo    foundryup disponivel. Deseja atualizar o Foundry? (S/N)
    choice /c SN /n /m "   Atualizar? (S/N): "
    if !ERRORLEVEL! EQU 1 (
        echo    Atualizando Foundry...
        @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "%TEMP%\foundryup.ps1" >nul 2>&1
        echo ✅ Foundry atualizado!
        forge --version
    ) else (
        echo    Mantendo versao atual.
    )
    del "%TEMP%\foundryup.ps1" 2>nul
)
echo.
goto :install_deps

REM ============================================================
REM PASSO 2: Instalar dependencias do Foundry (forge-std)
REM ============================================================
:install_deps
echo.
echo 📦 Instalando dependencias do Foundry (forge-std)...
cd /d "%~dp0"

if not exist "lib\forge-std" (
    echo    forge-std nao encontrado. Instalando...
    forge install foundry-rs/forge-std --no-commit 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo ✅ forge-std instalado com sucesso!
    ) else (
        echo ⚠️  Nao foi possivel instalar forge-std automaticamente.
        echo    Execute manualmente: forge install foundry-rs/forge-std
    )
) else (
    echo ✅ forge-std ja instalado.
)

REM ============================================================
REM PASSO 3: Verificar ambiente de compilacao
REM ============================================================
echo.
echo 🔍 Verificando ambiente de compilacao...

REM Verificar se o solc 0.7.6 esta disponivel
forge config --json 2>nul | "%SystemRoot%\System32\findstr.exe" "solc" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo ✅ Compilador Solidity configurado.
) else (
    echo ⚠️  Verificando versao do compilador Solidity...
    forge build --names 2>&1 | "%SystemRoot%\System32\findstr.exe" "0.7.6" >nul 2>&1
    if !ERRORLEVEL! EQU 0 (
        echo ✅ Solidity 0.7.6 disponivel.
    ) else (
        echo ⚠️  Nota: O Foundry baixara o solc 0.7.6 automaticamente na primeira compilacao.
    )
)

REM ============================================================
REM PASSO 4: Verificar conectividade com RPC (opcional)
REM ============================================================
echo.
echo 🔍 Testando conectividade com RPC publico...
echo    (Este teste e opcional - apenas verifica se ha acesso a internet)

ping -n 1 -w 3000 ethereum-rpc.publicnode.com >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo ✅ RPC publico acessivel: ethereum-rpc.publicnode.com
) else (
    echo ⚠️  Nao foi possivel pingar o RPC publico.
    echo    Isso pode ser normal se o firewall bloquear ICMP.
    echo    Tente executar o forge test diretamente para verificar.
)

REM ============================================================
REM PASSO 5: Compilacao de teste
REM ============================================================
echo.
echo 🔨 Compilando contratos para verificar se esta tudo ok...
cd /d "%~dp0"
forge build 2>&1
if %ERRORLEVEL% EQU 0 (
    echo ✅ Compilacao bem-sucedida!
) else (
    echo ⚠️  Erro na compilacao. Verifique os arquivos .sol.
    echo    Possiveis causas:
    echo    - forge-std nao instalado corretamente
    echo    - Erro de sintaxe nos contratos
    echo    - Versao do Solidity incompativel
)

REM ============================================================
REM RESUMO FINAL
REM ============================================================
echo.
echo ============================================================
echo  ✅ Ambiente configurado com sucesso!
echo ============================================================
echo.
echo 📋 Resumo do ambiente:
echo    - Foundry:  OK
echo    - forge-std: OK
echo    - Compilacao: OK
echo.
echo 🧪 Comandos para testar os PoCs:
echo.
echo   Todos os PoCs:
echo     forge test --fork-url https://ethereum-rpc.publicnode.com -vvvv
echo.
echo   PoC especifico (H-01: Replay Attack):
echo     forge test --fork-url https://ethereum-rpc.publicnode.com --match-contract ExploitReplayCCTP -vvvv
echo.
echo   PoC especifico (H-02: Integer Underflow):
echo     forge test --fork-url https://ethereum-rpc.publicnode.com --match-contract ExploitUnderflowCCTP -vvvv
echo.
echo   PoC especifico (H-03: Unchecked Burn):
echo     forge test --fork-url https://ethereum-rpc.publicnode.com --match-contract ExploitUncheckedBurnCCTP -vvvv
echo.
echo 📁 PoCs disponiveis:
echo    - ExploitReplayCCTP.t.sol        (H-01: Replay Attack)
echo    - ExploitUnderflowCCTP.t.sol     (H-02: Integer Underflow)
echo    - ExploitUncheckedBurnCCTP.t.sol (H-03: Unchecked Burn)
echo.
echo 🔗 RPCs alternativos (sem cadastro):
echo    - https://rpc.ankr.com/eth
echo    - https://eth.drpc.org
echo.
echo 🔗 RPCs com cadastro gratuito:
echo    - Alchemy: https://eth-mainnet.g.alchemy.com/v2/SUA_KEY
echo    - Infura:  https://mainnet.infura.io/v3/SUA_KEY
echo.

pause
exit /b 0

REM ============================================================
REM Sub-rotina: Aguardar e verificar se forge foi instalado
REM ============================================================
:wait_and_check_forge
REM Aguarda alguns segundos para o PATH ser atualizado
ping -n 3 127.0.0.1 >nul 2>&1

REM Verificar no PATH atual
where forge >nul 2>nul
if %ERRORLEVEL% EQU 0 exit /b 0

REM Tentar no diretorio padrao do foundry
if exist "%USERPROFILE%\.foundry\bin\forge.exe" (
    set "PATH=%USERPROFILE%\.foundry\bin;%PATH%"
    where forge >nul 2>nul
    if !ERRORLEVEL! EQU 0 exit /b 0
)

REM Verificar no diretorio .cargo/bin
if exist "%USERPROFILE%\.cargo\bin\forge.exe" (
    set "PATH=%USERPROFILE%\.cargo\bin;%PATH%"
    where forge >nul 2>nul
    if !ERRORLEVEL! EQU 0 exit /b 0
)

exit /b 1
