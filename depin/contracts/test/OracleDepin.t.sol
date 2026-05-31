// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../OracleDepin.sol";

/**
 * @title OracleDepinTest
 * @notice Testes Foundry para o contrato OracleDepin.
 */
contract OracleDepinTest is Test {
    OracleDepin public oracle;
    address public owner;
    address public proposer;
    address public disputer;
    address public arbiter;

    uint256 constant CHALLENGE_PERIOD = 1 hours;
    uint256 constant DISPUTE_FEE = 0.01 ether;

    uint256 ownerKey = 0x1234567890123456789012345678901234567890123456789012345678901234;
    uint256 proposerKey = 0x2234567890123456789012345678901234567890123456789012345678901234;

    function setUp() public {
        owner = vm.addr(ownerKey);
        proposer = vm.addr(proposerKey);
        disputer = address(0x3333);
        arbiter = address(0x4444);

        vm.prank(owner);
        oracle = new OracleDepin(CHALLENGE_PERIOD, DISPUTE_FEE);

        vm.prank(owner);
        oracle.authorizeProposer(proposer);

        vm.prank(owner);
        oracle.authorizeArbiter(arbiter);
    }

    function test_InitialState() public view {
        assertEq(oracle.owner(), owner);
        assertEq(oracle.challengePeriod(), CHALLENGE_PERIOD);
        assertEq(oracle.disputeFee(), DISPUTE_FEE);
        assertTrue(oracle.authorizedProposers(owner));
        assertTrue(oracle.authorizedProposers(proposer));
        assertTrue(oracle.arbiters(arbiter));
    }

    function test_ProposeData() public {
        bytes32 dataHash = keccak256("sensor reading: temp=25.5");
        bytes memory signature = _sign(dataHash, proposerKey);
        string memory metadata = "ipfs://QmTest";

        vm.prank(proposer);
        bool result = oracle.proposeData(dataHash, signature, metadata);

        assertTrue(result);

        (bytes32 hash, address prop, uint256 ts, uint256 challengeEnd, OracleDepin.ProposalStatus status, string memory meta) =
            oracle.getProposal(dataHash);

        assertEq(hash, dataHash);
        assertEq(prop, proposer);
        assertEq(uint256(status), uint256(OracleDepin.ProposalStatus.Pending));
        assertEq(meta, metadata);
        assertEq(challengeEnd, ts + CHALLENGE_PERIOD);
    }

    function test_AcceptData() public {
        bytes32 dataHash = keccak256("sensor reading: temp=25.5");
        bytes memory signature = _sign(dataHash, proposerKey);

        vm.prank(proposer);
        oracle.proposeData(dataHash, signature, "ipfs://QmTest");

        // Avanca tempo apos challenge period
        vm.warp(block.timestamp + CHALLENGE_PERIOD + 1);

        oracle.acceptData(dataHash);

        (, , , , OracleDepin.ProposalStatus status, ) = oracle.getProposal(dataHash);
        assertEq(uint256(status), uint256(OracleDepin.ProposalStatus.Accepted));
    }

    function test_DisputeData() public {
        bytes32 dataHash = keccak256("sensor reading: temp=25.5");
        bytes memory signature = _sign(dataHash, proposerKey);

        vm.prank(proposer);
        oracle.proposeData(dataHash, signature, "ipfs://QmTest");

        vm.deal(disputer, DISPUTE_FEE);
        vm.prank(disputer);
        oracle.disputeData{value: DISPUTE_FEE}(dataHash, "Invalid data");

        (, , , , OracleDepin.ProposalStatus status, ) = oracle.getProposal(dataHash);
        assertEq(uint256(status), uint256(OracleDepin.ProposalStatus.Disputed));

        (address disc, , string memory reason) = oracle.getDispute(dataHash);
        assertEq(disc, disputer);
        assertEq(reason, "Invalid data");
    }

    function test_ResolveDisputeAccept() public {
        bytes32 dataHash = keccak256("sensor reading: temp=25.5");
        bytes memory signature = _sign(dataHash, proposerKey);

        vm.prank(proposer);
        oracle.proposeData(dataHash, signature, "ipfs://QmTest");

        vm.deal(disputer, DISPUTE_FEE);
        vm.prank(disputer);
        oracle.disputeData{value: DISPUTE_FEE}(dataHash, "Invalid data");

        uint256 disputerBalanceBefore = disputer.balance;

        vm.prank(arbiter);
        oracle.resolveDispute(dataHash, true);

        (, , , , OracleDepin.ProposalStatus status, ) = oracle.getProposal(dataHash);
        assertEq(uint256(status), uint256(OracleDepin.ProposalStatus.Accepted));

        // Disputer deve receber a taxa de volta
        assertEq(disputer.balance, disputerBalanceBefore + DISPUTE_FEE);
    }

    function test_ResolveDisputeReject() public {
        bytes32 dataHash = keccak256("sensor reading: temp=25.5");
        bytes memory signature = _sign(dataHash, proposerKey);

        vm.prank(proposer);
        oracle.proposeData(dataHash, signature, "ipfs://QmTest");

        vm.deal(disputer, DISPUTE_FEE);
        vm.prank(disputer);
        oracle.disputeData{value: DISPUTE_FEE}(dataHash, "Invalid data");

        uint256 ownerBalanceBefore = owner.balance;

        vm.prank(arbiter);
        oracle.resolveDispute(dataHash, false);

        (, , , , OracleDepin.ProposalStatus status, ) = oracle.getProposal(dataHash);
        assertEq(uint256(status), uint256(OracleDepin.ProposalStatus.Rejected));

        // Owner recebe a taxa
        assertEq(owner.balance, ownerBalanceBefore + DISPUTE_FEE);
    }

    function test_RevertWhen_UnauthorizedProposer() public {
        bytes32 dataHash = keccak256("test");
        bytes memory signature = _sign(dataHash, 0x9999);

        vm.expectRevert("OracleDepin: unauthorized proposer");
        oracle.proposeData(dataHash, signature, "");
    }

    function test_RevertWhen_DisputeWithoutFee() public {
        bytes32 dataHash = keccak256("test");
        bytes memory signature = _sign(dataHash, proposerKey);

        vm.prank(proposer);
        oracle.proposeData(dataHash, signature, "");

        vm.expectRevert("OracleDepin: insufficient fee");
        vm.prank(disputer);
        oracle.disputeData(dataHash, "no fee");
    }

    function test_AuthorizeAndRevokeProposer() public {
        address newProposer = address(0x5555);

        vm.prank(owner);
        oracle.authorizeProposer(newProposer);
        assertTrue(oracle.authorizedProposers(newProposer));

        vm.prank(owner);
        oracle.revokeProposer(newProposer);
        assertFalse(oracle.authorizedProposers(newProposer));
    }

    function test_SetChallengePeriod() public {
        vm.prank(owner);
        oracle.setChallengePeriod(2 hours);
        assertEq(oracle.challengePeriod(), 2 hours);
    }

    function test_SetDisputeFee() public {
        vm.prank(owner);
        oracle.setDisputeFee(0.1 ether);
        assertEq(oracle.disputeFee(), 0.1 ether);
    }

    // =========================================================================
    // Helpers
    // =========================================================================

    function _sign(
        bytes32 hash,
        uint256 privateKey
    ) internal pure returns (bytes memory) {
        bytes32 ethSignedHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
        );
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, ethSignedHash);
        return abi.encodePacked(r, s, v);
    }
}
