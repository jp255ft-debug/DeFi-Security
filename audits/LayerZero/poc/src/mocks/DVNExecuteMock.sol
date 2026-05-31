// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DVNExecuteMock
 * @notice Mock que replica a vulnerabilidade de execução sem verificação no DVN.
 * 
 * A vulnerabilidade real: DVN.execute() chama _execute() que por sua vez chama
 * _shouldCheckHash(). Para operações do tipo "verify", _shouldCheckHash() retorna
 * false, permitindo que a mensagem seja executada sem verificação de hash.
 * 
 * Isso significa que um atacante pode fazer replay de chamadas verify() sem que
 * o hash seja validado, permitindo execução arbitrária de mensagens.
 */
contract DVNExecuteMock {
    address public endpoint;
    uint256 public executionCount;
    
    // Simula o estado de mensagens executadas
    mapping(bytes32 => bool) public executedMessages;
    
    // Tipos de operação
    uint8 public constant TYPE_VERIFY = 1;
    uint8 public constant TYPE_COMMIT = 2;
    
    event MessageExecuted(bytes32 indexed messageHash, uint8 operationType, address indexed caller);
    event HashCheckSkipped(bytes32 indexed messageHash, uint8 operationType);
    
    constructor(address _endpoint) {
        endpoint = _endpoint;
    }
    
    /**
     * @notice Função que replica execute() do DVN real.
     * A vulnerabilidade: para TYPE_VERIFY, _shouldCheckHash() retorna false,
     * permitindo execução sem verificação de hash.
     */
    function execute(uint8 _operationType, bytes calldata _message) external returns (bool) {
        bytes32 messageHash = keccak256(_message);
        
        // Replica _shouldCheckHash() - retorna false para TYPE_VERIFY
        bool shouldCheckHash = _shouldCheckHash(_operationType);
        
        if (!shouldCheckHash) {
            emit HashCheckSkipped(messageHash, _operationType);
        } else {
            // Se deveria verificar o hash, mas não estamos verificando nada
            // (no mock, apenas simulamos que passou)
            require(_operationType == TYPE_COMMIT, "InvalidOperation");
        }
        
        // Marca como executada (mesmo sem verificação de hash)
        executedMessages[messageHash] = true;
        executionCount++;
        
        emit MessageExecuted(messageHash, _operationType, msg.sender);
        return true;
    }
    
    /**
     * @notice Replica _shouldCheckHash() do DVN real.
     * Para TYPE_VERIFY, retorna false - a vulnerabilidade!
     * Isso significa que mensagens do tipo verify são executadas sem
     * qualquer verificação de hash, permitindo replay de mensagens.
     */
    function _shouldCheckHash(uint8 _operationType) internal pure returns (bool) {
        // A vulnerabilidade: TYPE_VERIFY (1) retorna false
        // Apenas TYPE_COMMIT (2) retorna true
        return _operationType == TYPE_COMMIT;
    }
    
    /**
     * @notice Verifica se uma mensagem foi executada.
     */
    function isExecuted(bytes32 messageHash) external view returns (bool) {
        return executedMessages[messageHash];
    }
}
