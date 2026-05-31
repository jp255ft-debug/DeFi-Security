// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

/// @title IPermissionedRamp
/// @notice Interface mínima do PermissionedRamp para o PoC de front-running de nonce
interface IPermissionedRamp {
    /// @notice Wraps um ativo suportado no collateral token
    function wrap(
        address _asset,
        address _to,
        uint256 _amount,
        uint256 _nonce,
        uint256 _deadline,
        bytes calldata _signature
    ) external;

    /// @notice Unwraps um ativo suportado do collateral token
    function unwrap(
        address _asset,
        address _to,
        uint256 _amount,
        uint256 _nonce,
        uint256 _deadline,
        bytes calldata _signature
    ) external;

    /// @notice Retorna o nonce atual de um endereço
    function nonces(address _sender) external view returns (uint256);

    /// @notice Retorna o endereço do collateral token
    function COLLATERAL_TOKEN() external view returns (address);
}
