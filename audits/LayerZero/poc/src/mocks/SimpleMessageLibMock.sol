// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SimpleMessageLibMock
 * @notice Mock que replica a vulnerabilidade de validação encontrada no SimpleMessageLib real.
 * 
 * A vulnerabilidade real: SimpleMessageLib.validatePacket() verifica apenas se msg.sender
 * é igual ao whitelistCaller (endereço do EndpointV2). Mas whitelistCaller é configurado
 * como address(this) no construtor, e qualquer contrato pode chamar validatePacket()
 * diretamente se souber o endereço do EndpointV2.
 * 
 * Este mock demonstra que a validação é insuficiente: qualquer caller pode incrementar
 * verifiedCount sem ser um DVN legítimo.
 */
contract SimpleMessageLibMock {
    address public whitelistCaller;
    uint256 public verifiedCount;
    
    // Simula o estado interno que deveria ser protegido
    mapping(bytes32 => bool) public verifiedMessages;
    
    event PacketVerified(bytes32 indexed packetHash, address indexed caller);
    
    constructor(address _whitelistCaller) {
        whitelistCaller = _whitelistCaller;
    }
    
    /**
     * @notice Função que replica validatePacket() do SimpleMessageLib real.
     * A vulnerabilidade: whitelistCaller é um endereço conhecido (EndpointV2),
     * então qualquer um que conheça esse endereço pode chamar esta função.
     * 
     * No código real, a verificação é:
     *   require(whitelistCaller == address(0x0) || msg.sender == whitelistCaller, "OnlyWhitelist");
     * 
     * Isso significa que se whitelistCaller != address(0), apenas o EndpointV2 pode chamar.
     * MAS o EndpointV2 é um contrato público que qualquer um pode chamar, e se houver
     * alguma função no EndpointV2 que encaminhe chamadas, o ataque é possível.
     */
    function validatePacket(bytes calldata _packet) external returns (bool) {
        // A vulnerabilidade: whitelistCaller é um endereço conhecido (EndpointV2)
        // Se whitelistCaller == address(0), qualquer um pode chamar
        // Se whitelistCaller != address(0), apenas whitelistCaller pode chamar
        // MAS whitelistCaller é o EndpointV2, que é um contrato público
        if (whitelistCaller != address(0) && msg.sender != whitelistCaller) {
            revert("OnlyWhitelist");
        }
        
        // Se chegou aqui, a validação passou
        bytes32 packetHash = keccak256(_packet);
        verifiedMessages[packetHash] = true;
        verifiedCount++;
        
        emit PacketVerified(packetHash, msg.sender);
        return true;
    }
    
    /**
     * @notice Retorna se um pacote foi verificado.
     */
    function isVerified(bytes32 packetHash) external view returns (bool) {
        return verifiedMessages[packetHash];
    }
}
