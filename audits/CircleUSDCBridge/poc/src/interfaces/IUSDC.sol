// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @title IUSDC — Interface mínima do token USDC (ERC20 + burn/mint)
interface IUSDC {
    /// @notice Transfere tokens de um endereço para outro (com aprovação)
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);

    /// @notice Transfere tokens
    function transfer(address _to, uint256 _value) external returns (bool);

    /// @notice Aprova gasto
    function approve(address _spender, uint256 _value) external returns (bool);

    /// @notice Saldo de um endereço
    function balanceOf(address _account) external view returns (uint256);

    /// @notice Allowance
    function allowance(address _owner, address _spender) external view returns (uint256);

    /// @notice Queima tokens
    function burn(uint256 _amount) external;

    /// @notice Mina tokens
    function mint(address _to, uint256 _amount) external;

    /// @notice Pausa o contrato
    function paused() external view returns (bool);
}
