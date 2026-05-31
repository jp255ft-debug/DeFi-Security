// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title MaliciousToken
 * @notice Mock token que simula um LatamStable malicioso para testar reentrância
 * @dev Este token reentra no LimitedMinter.mint() para tentar quebrar o limite diário
 */
contract MaliciousToken is ERC20, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    address public limitedMinter;
    bool public doReentrancy;
    uint256 public reentrancyAmount;

    constructor() ERC20("Malicious", "MAL") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function setLimitedMinter(address _limitedMinter) external {
        limitedMinter = _limitedMinter;
    }

    function setReentrancy(bool _doReentrancy, uint256 _amount) external {
        doReentrancy = _doReentrancy;
        reentrancyAmount = _amount;
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
        if (doReentrancy && limitedMinter != address(0)) {
            doReentrancy = false; // prevent infinite loop
            // Reentra no LimitedMinter para mintar mais
            (bool success, ) = limitedMinter.call(
                abi.encodeWithSignature("mint(address,uint256)", address(this), reentrancyAmount)
            );
            require(success, "Reentrancy failed");
        }
    }

    function hasRole(bytes32 role, address account) public view override returns (bool) {
        return super.hasRole(role, account);
    }

    function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
