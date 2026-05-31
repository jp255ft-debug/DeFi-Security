### M-01: LimitedMinter — State Update After External Call Enables Reentrancy

**Severity:** Medium (CVSSv3: 6.5)
**Contract:** `LimitedMinter`
**Function:** `mintTo`

**Description:**
The `LimitedMinter.mintTo()` function updates the `mintedPerDay` state variable **after** making an external call to `MockToken(token).mint(to, mintAmount)`. While the function is protected by OpenZeppelin's `ReentrancyGuard`, the state-update-after-external-call pattern is a well-known anti-pattern that could become exploitable if:

1. The `nonReentrant` modifier is accidentally removed during upgrades
2. A different code path is introduced that calls `mintTo` without the modifier
3. The token contract has a callback that could trigger another mint

**Vulnerable Code:**
```solidity
function mintTo(address token, address to, uint256 mintAmount)
    external
    onlyRole(MINTER_ROLE)
    nonReentrant
    whenNotPaused
{
    if (mintAmount == 0) revert MintAmountZero();
    if (to == address(0)) revert InvalidRecipient();
    if (!tokenConfigs[token].exists) revert TokenNotRegistered();

    TokenConfig storage config = tokenConfigs[token];
    uint256 currentDay = block.timestamp / 1 days;
    uint256 alreadyMinted = mintedPerDay[token][currentDay];

    if (alreadyMinted + mintAmount > config.dailyMaxMint) revert ExceedsDailyMintLimit();
    mintedPerDay[token][currentDay] = alreadyMinted + mintAmount;

    MockToken(token).mint(to, mintAmount);  // External call AFTER state update
}
```

**Impact:**
If the `nonReentrant` modifier is removed, a malicious token with a callback could reenter `mintTo()` and mint tokens beyond the daily limit before the state is updated.

**Mitigation:**
1. Keep the `nonReentrant` modifier (currently present — good)
2. Move the state update after the external call as defense-in-depth
3. Consider using the checks-effects-interactions pattern

**PoC File:** `poc/test/ExploitLimitedMinterReentrancy.t.sol`
**Test Command:** `forge test --match-contract ExploitLimitedMinterReentrancy -vvv`

---

### M-02: BridgeDeposit — Missing Validation on Fee Configuration

**Severity:** Medium (CVSSv3: 5.5)
**Contract:** `BridgeDeposit`
**Functions:** `setFeeCollector`, `updateRouteFee`

**Description:**
The `BridgeDeposit` contract lacks validation when configuring fees:

1. **`setFeeCollector(address(0))` is allowed** — Setting `feeCollector` to `address(0)` causes all deposits with fees to revert, effectively bricking the deposit functionality for routes with fees configured.

2. **`updateRouteFee(token, chain, 0)` is allowed** — A `FEE_MANAGER` can set the fee to zero for any route, allowing users to bypass fees entirely.

3. **No consistency check** — There is no validation that `feeCollector` is set when routes have non-zero fees configured.

**Vulnerable Code:**
```solidity
function setFeeCollector(address newFeeCollector) external onlyRole(DEFAULT_ADMIN_ROLE) {
    feeCollector = newFeeCollector;  // No validation — address(0) is accepted
}

function updateRouteFee(address token, uint256 destChainId, uint256 newFixedFee)
    external onlyRole(FEE_MANAGER_ROLE)
{
    RouteConfig storage route = routeConfigs[token][destChainId];
    if (!route.enabled) revert InvalidRoute();
    route.fixedFee = newFixedFee;  // No minimum fee — zero is accepted
}
```

**Impact:**
- An admin can accidentally brick deposits by setting `feeCollector = address(0)`
- A fee manager can bypass the fee system by setting fees to zero
- Users may lose funds if deposits fail due to zero fee collector

**Mitigation:**
1. Add `require(newFeeCollector != address(0), "Invalid fee collector")` in `setFeeCollector()`
2. Add `require(newFixedFee > 0, "Fee must be > 0")` in `updateRouteFee()`
3. Add a consistency check when setting fee collector against existing routes

**PoC File:** `poc/test/ExploitBridgeFeeBypass.t.sol`
**Test Command:** `forge test --match-contract ExploitBridgeFeeBypass -vvv`
