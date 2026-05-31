### L-01: LatamStable — Direct Mint Bypasses LimitedMinter Controls

**Severity:** Low (CVSSv3: 3.5)
**Contract:** `LatamStable`
**Function:** `mint`

**Description:**
The `LatamStable.mint()` function is a public function that only checks for `MINTER_ROLE`. Any address with `MINTER_ROLE` on the token can mint unlimited amounts directly, completely bypassing the `LimitedMinter` contract's daily mint limits.

The `LimitedMinter` is only effective if it is the **sole holder** of `MINTER_ROLE` on the token. However, there is no guarantee of this — the admin can grant `MINTER_ROLE` to other addresses at any time.

**Vulnerable Code:**
```solidity
function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
    _mint(to, amount);  // No limit check — any MINTER_ROLE can mint unlimited
}
```

**Impact:**
- Any address with `MINTER_ROLE` can mint unlimited tokens
- The `LimitedMinter`'s daily limit is completely bypassed
- Token supply can be inflated arbitrarily

**Mitigation:**
1. Remove the public `mint()` function from `LatamStable` and force all minting through `LimitedMinter`
2. Or add a `onlyLimitedMinter` modifier that checks the caller is the authorized minter
3. Or implement supply cap and daily limit directly in the token contract

**PoC File:** `poc/test/ExploitLatamStableUnlimitedMint.t.sol`
**Test Command:** `forge test --match-contract ExploitLatamStableUnlimitedMint -vvv`
