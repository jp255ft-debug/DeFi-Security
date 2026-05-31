### H-01: BridgeDeposit — Missing Merkle Proof Verification Allows Arbitrary Token Minting

**Severity:** High (CVSSv3: 8.5)
**Contract:** `BridgeDeposit`
**Function:** `fulfillBridgeMint`

**Description:**
The `BridgeDeposit.fulfillBridgeMint()` function allows any address with `BRIDGE_OPERATOR_ROLE` to mint tokens on the destination chain without any cryptographic proof (Merkle proof or signature) that the corresponding burn actually occurred on the source chain.

The function only checks:
1. The caller has `BRIDGE_OPERATOR_ROLE`
2. The `sourceChainId` is different from the current chain
3. The fulfillment key (sourceChainId + sourceTxHash + sourceDepositId) hasn't been used before (idempotency)

There is **no verification** that a legitimate `PacketSent` or `Burn` event occurred on the source chain. An operator can simply invent arbitrary values for `sourceChainId`, `sourceTxHash`, and `sourceDepositId`.

**Vulnerable Code:**
```solidity
function fulfillBridgeMint(
    address token,
    address to,
    uint256 amount,
    uint256 sourceChainId,
    bytes32 sourceTxHash,
    uint256 sourceDepositId
)
    external
    nonReentrant
    whenNotPaused
    onlyRole(BRIDGE_OPERATOR_ROLE)
{
    if (sourceChainId == block.chainid) revert InvalidSourceChain();

    bytes32 fulfillmentKey = keccak256(abi.encodePacked(sourceChainId, sourceTxHash, sourceDepositId));
    if (bridgeFulfilled[fulfillmentKey]) revert BridgeAlreadyFulfilled();
    if (amount == 0) revert AmountZero();
    if (to == address(0)) revert InvalidRecipient();

    bridgeFulfilled[fulfillmentKey] = true;
    limitedMinter.mintTo(token, to, amount);
}
```

**Impact:**
A malicious or compromised `BRIDGE_OPERATOR` can:
- Mint arbitrary amounts of any registered token (up to the daily limit)
- Mint tokens to any address, including themselves
- Execute multiple mints with different fake transaction hashes
- Drain the bridge's minting capacity

The only protection is the daily mint limit in `LimitedMinterBridge`, which can be bypassed by minting across multiple days.

**Mitigation:**
1. Implement Merkle proof verification — require a valid Merkle proof that the burn event occurred on the source chain
2. Alternatively, implement ECDSA signature verification from a trusted oracle/relayer
3. Consider adding a challenge period or multi-sig requirement for large mints

**PoC File:** `poc/test/ExploitBridgeDepositNoMerkle.t.sol`
**Test Command:** `forge test --match-contract ExploitBridgeDepositNoMerkle -vvv`
