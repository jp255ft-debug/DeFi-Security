# F-50543: `MonetrixVault.settle()` ignores `bridgeRetentionAmount`, enabling yield declaration on bridge-reserved USDC

## Severity

**Medium** — Causes guaranteed DoS of `keeperBridge()` when `bridgeRetentionAmount > 0` and yield is declared. No direct fund loss, but core protocol functionality (L1 bridge) becomes inoperable until new deposits replenish the vault.

## Files

- [`src/core/MonetrixVault.sol`](https://github.com/code-423n4/2026-04-monetrix/blob/main/src/core/MonetrixVault.sol)
  - `settle()` (lines 364–375)
  - `netBridgeable()` (lines 575–580)
  - `yieldShortfall()` (lines 587–596)

## Description

The `settle()` function calculates available EVM USDC for yield declaration as:

```solidity
uint256 vaultBal = usdc.balanceOf(address(this));
uint256 shortfall_ = IRedeemEscrow(redeemEscrow).shortfall();
uint256 available = vaultBal > shortfall_ ? vaultBal - shortfall_ : 0;
require(available >= proposedYield, "insufficient EVM USDC");
```

This only reserves `shortfall` (pending redemptions), but **ignores `bridgeRetentionAmount`** — a Governor-set working balance that must remain in the vault for L1 bridge operations.

Compare with `netBridgeable()` (used by `keeperBridge()`):

```solidity
function netBridgeable() public view returns (uint256) {
    uint256 bal = usdc.balanceOf(address(this));
    uint256 sf = IRedeemEscrow(redeemEscrow).shortfall();
    uint256 reserved = sf + bridgeRetentionAmount;  // ← includes retention!
    return bal > reserved ? bal - reserved : 0;
}
```

And `yieldShortfall()`:

```solidity
uint256 res = IRedeemEscrow(redeemEscrow).shortfall() + bridgeRetentionAmount;  // ← includes retention!
uint256 available = vaultBal > res ? vaultBal - res : 0;
```

Both `netBridgeable()` and `yieldShortfall()` correctly include `bridgeRetentionAmount` in the reserved amount, but `settle()` does not. This inconsistency means:

1. Governor sets `bridgeRetentionAmount = 500_000e6` (500k USDC)
2. Vault has 600k USDC, shortfall is 50k, surplus is positive
3. `settle()` sees `available = 600k - 50k = 550k` and allows yield up to 550k
4. Operator declares 200k yield → 200k USDC moves to YieldEscrow
5. Vault now has 400k USDC, but `bridgeRetentionAmount` is 500k
6. `keeperBridge()` sees `netBridgeable() = 400k - 50k - 500k = 0` → **reverts**
7. Bridge to L1 is blocked until new deposits replenish the vault

## Proof of Concept

The PoC demonstrates:
1. Deploy full protocol with `bridgeRetentionAmount = 500_000e6`
2. Deposit 600k USDC → vault has 600k
3. Mock L1 backing so `distributableSurplus()` is positive
4. Call `settle(200_000e6)` — succeeds despite bridge retention
5. Call `keeperBridge()` — reverts with "nothing to bridge"
6. Bridge functionality is DoS'd

```solidity
function test_submissionValidity() public {
    // ── Setup: Governor sets bridge retention ──
    vm.startPrank(admin);
    vault.setBridgeRetentionAmount(500_000e6);
    vm.stopPrank();

    // ── User deposits 600k USDC ──
    _deposit(user1, 600_000e6);
    assertEq(usdc.balanceOf(address(vault)), 600_000e6);

    // ── Mock L1 backing so surplus is positive ──
    // Accountant reads L1 spot USDC via 0x801 precompile.
    // 200_001e6 USDC on L1 → surplus of 200_001e6 - 0 = 200_001e6
    _mockVaultL1SpotUsdc(TokenMath.usdcEvmToL1Wei(200_001e6)); // 200_001e6 * 100 = 20_000_100e8 L1 wei

    // ── Advance time past minSettlementInterval (20h) ──
    vm.warp(block.timestamp + 21 hours);

    // ── Operator settles 200k yield ──
    // settle() sees available = 600k - 0 = 600k → allows 200k
    vm.prank(operator);
    vault.settle(200_000e6);

    // ── Vault now has 400k USDC (600k - 200k sent to YieldEscrow) ──
    assertEq(usdc.balanceOf(address(vault)), 400_000e6);
    assertEq(usdc.balanceOf(address(yieldEscrow)), 200_000e6);

    // ── Advance time past bridgeInterval (6h) ──
    vm.warp(block.timestamp + 7 hours);

    // ── keeperBridge() reverts ──
    // netBridgeable() = 400k - 0 - 500k = -100k → 0 → "nothing to bridge"
    vm.prank(operator);
    vm.expectRevert("nothing to bridge");
    vault.keeperBridge(MonetrixVault.BridgeTarget.Vault);

    // ── Bridge to L1 is DoS'd ──
    assertEq(vault.netBridgeable(), 0);
}
```

## Impact

- **Guaranteed DoS** of `keeperBridge()` whenever `vaultBal - shortfall < bridgeRetentionAmount + proposedYield`
- Bridge is the only path to move USDC to L1 for hedge operations, HLP deposits, and BLP supply
- Protocol cannot deploy capital to L1 until new user deposits replenish the vault
- Under bank-run conditions (high shortfall), the window of DoS is amplified

## Recommended Mitigation

Align `settle()` with `netBridgeable()` and `yieldShortfall()` by including `bridgeRetentionAmount` in the reserved amount:

```solidity
function settle(uint256 proposedYield) ... {
    uint256 vaultBal = usdc.balanceOf(address(this));
    uint256 shortfall_ = IRedeemEscrow(redeemEscrow).shortfall();
    uint256 reserved = shortfall_ + bridgeRetentionAmount;  // ← FIX
    uint256 available = vaultBal > reserved ? vaultBal - reserved : 0;
    require(available >= proposedYield, "insufficient EVM USDC");
    ...
}
```

Alternatively, if the design intent is that `bridgeRetentionAmount` should not block yield (as the current comment suggests), then `netBridgeable()` and `yieldShortfall()` should be updated to match — but this would allow bridge operations to fail silently, which is worse.

## References

- `settle()` comment (lines 361–363): explicitly states `bridgeRetentionAmount` is "NOT a solvency invariant and must not block yield routing"
- `netBridgeable()` (line 578): includes `bridgeRetentionAmount` in reserved calculation
- `yieldShortfall()` (line 593): includes `bridgeRetentionAmount` in reserved calculation
