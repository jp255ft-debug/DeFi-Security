// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @title IMessageTransmitterV2 — Interface mínima para o contrato MessageTransmitterV2 do CCTP V2
interface IMessageTransmitterV2 {
    /// @notice Recebe e processa uma mensagem com atestação
    /// @param _message Mensagem codificada
    /// @param _attestation Atestação assinada pelo AttesterManager
    /// @return success Verdadeiro se a mensagem foi processada com sucesso
    function receiveMessage(bytes calldata _message, bytes calldata _attestation)
        external
        returns (bool success);

    /// @notice Verifica se um nonce já foi usado
    /// @param _nonce Nonce a verificar
    /// @return 0 se não usado, block number se usado
    function usedNonces(bytes32 _nonce) external view returns (uint256);

    /// @notice Retorna o domínio local
    function localDomain() external view returns (uint32);

    /// @notice Versão do contrato
    function version() external view returns (uint32);
}
