// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @title ITokenMinterV2 — Interface mínima para o contrato TokenMinterV2 do CCTP V2
interface ITokenMinterV2 {
    /// @notice Queima tokens (chamado pelo TokenMessenger após transferência)
    /// @param _burnToken Endereço do token a queimar
    /// @param _amount Quantidade a queimar
    function burn(address _burnToken, uint256 _amount) external;

    /// @notice Mina tokens (chamado pelo TokenMessenger ao receber mensagem)
    /// @param _mintToken Endereço do token a minar
    /// @param _recipient Endereço do destinatário
    /// @param _amount Quantidade a minar
    function mint(address _mintToken, address _recipient, uint256 _amount) external;

    /// @notice Retorna o token controller
    function tokenController() external view returns (address);

    /// @notice Retorna o local message transmitter
    function localMessageTransmitter() external view returns (address);
}
