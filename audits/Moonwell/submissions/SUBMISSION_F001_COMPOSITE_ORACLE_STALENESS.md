# 🐛 Submissão Code4rena — Moonwell Bug Bounty

## Finding: ChainlinkCompositeOracle — Missing Staleness Check

**Severity:** HIGH
**Category:** Oracle Manipulation
**Contract:** `ChainlinkCompositeOracle.sol`
**Lines:** 180-195

---

## Description

The `ChainlinkCompositeOracle.getPriceAndDecimals()` function fails to validate whether the Chainlink price data is stale. It only checks:

```solidity
bool valid = price > 0 && answeredInRound == roundId;
require(valid, "CLCOracle: Oracle data is invalid");
```

**Missing check:** The function does **not** verify `updatedAt` (the timestamp of the last Chainlink update). A Chainlink feed that hasn't been updated for hours/days will return an old price, and the composite oracle will accept it as valid.

## Comparison with ChainlinkOracle.sol

The `ChainlinkOracle.sol` (sister contract) **does** perform the staleness check correctly:

```solidity
// ChainlinkOracle.sol lines 101-104
(, int256 answer, , uint256 updatedAt, ) = AggregatorV3Interface(feed).latestRoundData();
require(answer > 0, "Chainlink price cannot be lower than 0");
require(updatedAt != 0, "Round is in incompleted state");
```

The `ChainlinkCompositeOracle` **omits** this check, creating an inconsistency between the two oracles.

## Impact

1. **Stale price acceptance:** If a Chainlink feed stops updating (e.g., cbETH/ETH feed freezes), the `ChainlinkCompositeOracle` will continue returning the last known price as if it were fresh.
2. **Exploitation in volatility:** An attacker can exploit this in high-volatility scenarios where the real asset price moves but the composite oracle returns an outdated price.
3. **MIP-X43 context:** The February 2026 attack that caused a $1.78M loss was exactly about incorrect cbETH oracle configuration. A staleness check would have mitigated the impact.

## Proof of Concept

The PoC demonstrates:
1. `ChainlinkCompositeOracle.getPriceAndDecimals()` accepts a price with `updatedAt = 0`
2. `ChainlinkOracle.sol` would reject the same price with `"Round is in incompleted state"`
3. Mixed staleness (one feed fresh, one stale) produces incorrect composite prices

**PoC file:** `audits/Moonwell/poc/test/ExploitCompositeOracleStaleness.t.sol`

### Test Results

```
test_CompositeOracleAcceptsStalePrice()  → PASS (no revert)
test_ChainlinkOracleWouldRejectStalePrice() → PASS (reverts as expected)
test_CompositePriceWithMixedStaleness() → PASS (shows ~2.9% price difference)
```

## Recommended Fix

Add staleness check in `getPriceAndDecimals()`:

```solidity
function getPriceAndDecimals(address oracleAddress) public view returns (int256, uint8) {
    (
        uint80 roundId,
        int256 price,
        ,
        uint256 updatedAt,
        uint80 answeredInRound
    ) = AggregatorV3Interface(oracleAddress).latestRoundData();
    bool valid = price > 0 && answeredInRound == roundId && updatedAt != 0;
    require(valid, "CLCOracle: Oracle data is invalid");
    uint8 oracleDecimals = AggregatorV3Interface(oracleAddress).decimals();
    return (price, oracleDecimals);
}
```

## Severity Rationale

- **HIGH** because it affects all composite oracles (cbETH, wstETH, rETH) across all chains (Base, Optimism, Moonbeam, Moonriver)
- Directly related to the MIP-X43 incident that caused $1.78M in losses
- The sister contract (`ChainlinkOracle.sol`) already implements this check, making this an obvious omission
- Can lead to incorrect liquidations and bad debt accumulation
