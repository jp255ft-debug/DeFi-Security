// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../DataVerifier.sol";

/**
 * @title DataVerifierTest
 * @notice Testes Foundry para o contrato DataVerifier.
 */
contract DataVerifierTest is Test {
    DataVerifier public verifier;
    address public owner;
    address public authorizedSigner;
    address public unauthorizedSigner;

    // Chaves para teste (NUNCA use em producao!)
    uint256 ownerKey = 0x1234567890123456789012345678901234567890123456789012345678901234;
    uint256 signerKey = 0x2234567890123456789012345678901234567890123456789012345678901234;
    uint256 badKey = 0x3234567890123456789012345678901234567890123456789012345678901234;

    function setUp() public {
        owner = vm.addr(ownerKey);
        authorizedSigner = vm.addr(signerKey);
        unauthorizedSigner = vm.addr(badKey);

        vm.prank(owner);
        verifier = new DataVerifier();

        vm.prank(owner);
        verifier.authorizeSigner(authorizedSigner);
    }

    function test_InitialState() public view {
        assertEq(verifier.owner(), owner);
        assertTrue(verifier.authorizedSigners(owner));
        assertTrue(verifier.authorizedSigners(authorizedSigner));
        assertEq(verifier.totalRecords(), 0);
    }

    function test_StoreData() public {
        bytes32 dataHash = keccak256("test data");
        bytes memory signature = _sign(dataHash, signerKey);

        vm.prank(authorizedSigner);
        bool result = verifier.storeData(dataHash, signature);

        assertTrue(result);
        assertEq(verifier.totalRecords(), 1);

        (bytes32 storedHash, address storedSigner, uint256 timestamp, bool exists) =
            verifier.records(dataHash);
        assertEq(storedHash, dataHash);
        assertEq(storedSigner, authorizedSigner);
        assertTrue(exists);
        assertGt(timestamp, 0);
    }

    function test_RevertWhen_UnauthorizedSigner() public {
        bytes32 dataHash = keccak256("test data");
        bytes memory signature = _sign(dataHash, badKey);

        vm.prank(unauthorizedSigner);
        vm.expectRevert("DataVerifier: unauthorized signer");
        verifier.storeData(dataHash, signature);
    }

    function test_RevertWhen_DuplicateData() public {
        bytes32 dataHash = keccak256("test data");
        bytes memory signature = _sign(dataHash, signerKey);

        vm.prank(authorizedSigner);
        verifier.storeData(dataHash, signature);

        vm.prank(authorizedSigner);
        vm.expectRevert("DataVerifier: already exists");
        verifier.storeData(dataHash, signature);
    }

    function test_StoreRawData() public {
        bytes memory rawData = "raw sensor data";
        bytes32 expectedHash = keccak256(rawData);
        bytes memory signature = _sign(expectedHash, signerKey);

        vm.prank(authorizedSigner);
        bytes32 returnedHash = verifier.storeRawData(rawData, signature);

        assertEq(returnedHash, expectedHash);
        assertTrue(verifier.verify(expectedHash));
    }

    function test_Verify() public {
        bytes32 dataHash = keccak256("test data");
        bytes memory signature = _sign(dataHash, signerKey);

        assertFalse(verifier.verify(dataHash));

        vm.prank(authorizedSigner);
        verifier.storeData(dataHash, signature);

        assertTrue(verifier.verify(dataHash));
    }

    function test_GetRecord() public {
        bytes32 dataHash = keccak256("test data");
        bytes memory signature = _sign(dataHash, signerKey);

        vm.prank(authorizedSigner);
        verifier.storeData(dataHash, signature);

        (bytes32 hash, address signer, uint256 ts, bool exists) =
            verifier.getRecord(dataHash);
        assertEq(hash, dataHash);
        assertEq(signer, authorizedSigner);
        assertTrue(exists);
    }

    function test_AuthorizeAndRevokeSigner() public {
        address newSigner = address(0x9999);

        vm.prank(owner);
        verifier.authorizeSigner(newSigner);
        assertTrue(verifier.authorizedSigners(newSigner));

        vm.prank(owner);
        verifier.revokeSigner(newSigner);
        assertFalse(verifier.authorizedSigners(newSigner));
    }

    function test_RevertWhen_NonOwnerAuthorizes() public {
        vm.prank(authorizedSigner);
        vm.expectRevert("DataVerifier: not owner");
        verifier.authorizeSigner(address(0x8888));
    }

    function test_TransferOwnership() public {
        address newOwner = address(0x7777);

        vm.prank(owner);
        verifier.transferOwnership(newOwner);

        assertEq(verifier.owner(), newOwner);
        assertTrue(verifier.authorizedSigners(newOwner));
    }

    function testFuzz_StoreMultiple(bytes32[] memory hashes) public {
        vm.assume(hashes.length > 0 && hashes.length <= 10);

        for (uint256 i = 0; i < hashes.length; i++) {
            bytes memory sig = _sign(hashes[i], signerKey);
            vm.prank(authorizedSigner);
            verifier.storeData(hashes[i], sig);
        }

        assertEq(verifier.totalRecords(), hashes.length);
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
