// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @title ITokenMessengerV2 — Interface mínima para o contrato TokenMessengerV2 do CCTP V2
interface ITokenMessengerV2 {
    /// @notice Deposita e queima tokens para iniciar uma transferência cross-chain
    /// @param _amount Quantidade de tokens a depositar
    /// @param _destinationDomain ID da chain de destino
    /// @param _mintRecipient Endereço do destinatário na chain de destino
    /// @param _burnToken Endereço do token a ser queimado
    /// @return _nonce Nonce da mensagem gerada
    function depositForBurn(
        uint256 _amount,
        uint32 _destinationDomain,
        bytes32 _mintRecipient,
        address _burnToken
    ) external returns (uint64 _nonce);

    /// @notice Deposita e queima tokens com taxa
    /// @param _amount Quantidade de tokens a depositar
    /// @param _destinationDomain ID da chain de destino
    /// @param _mintRecipient Endereço do destinatário na chain de destino
    /// @param _burnToken Endereço do token a ser queimado
    /// @param _fee Taxa a ser cobrada
    /// @return _nonce Nonce da mensagem gerada
    function depositForBurnWithFee(
        uint256 _amount,
        uint32 _destinationDomain,
        bytes32 _mintRecipient,
        address _burnToken,
        uint256 _fee
    ) external returns (uint64 _nonce);

    /// @notice Handler para mensagens recebidas (finalizadas)
    function handleReceiveMessage(
        bytes calldata _messageBody,
        bytes32 _sender,
        uint32 _remoteDomain
    ) external returns (bool);

    /// @notice Handler para mensagens recebidas (não finalizadas)
    function handleReceiveUnfinalizedMessage(
        bytes calldata _messageBody,
        bytes32 _sender,
        uint32 _remoteDomain
    ) external returns (bool);

    /// @notice Retorna o endereço do MessageTransmitter local
    function localMessageTransmitter() external view returns (address);

    /// @notice Retorna o endereço do TokenMinter local
    function localMinter() external view returns (address);
}
