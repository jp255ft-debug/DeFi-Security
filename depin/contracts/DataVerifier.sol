// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DataVerifier
 * @notice Contrato de verificacao on-chain para dados DePIN.
 *         Recebe dados assinados, verifica a assinatura com ecrecover,
 *         e armazena o hash de forma imutavel.
 *
 * @dev Usa ECDSA para verificar que os dados foram assinados por um
 *      remetente autorizado (authorizedSigner).
 *
 * Fluxo:
 *   1. Cliente assina dados off-chain com Web3.py
 *   2. Envia transacao para storeData()
 *   3. Contrato verifica assinatura com ecrecover
 *   4. Se valida, armazena hash + metadados
 */
contract DataVerifier {
    // =========================================================================
    // Tipos
    // =========================================================================

    struct DataRecord {
        bytes32 dataHash;
        address signer;
        uint256 timestamp;
        bool exists;
    }

    // =========================================================================
    // Variaveis de Estado
    // =========================================================================

    /// @notice Mapeamento de hash de dados -> registro
    mapping(bytes32 => DataRecord) public records;

    /// @notice Conjunto de signers autorizados
    mapping(address => bool) public authorizedSigners;

    /// @notice Endereco do owner do contrato
    address public owner;

    /// @notice Total de registros armazenados
    uint256 public totalRecords;

    // =========================================================================
    // Eventos
    // =========================================================================

    event DataStored(
        bytes32 indexed dataHash,
        address indexed signer,
        uint256 timestamp
    );

    event SignerAuthorized(address indexed signer);
    event SignerRevoked(address indexed signer);
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    // =========================================================================
    // Modifiers
    // =========================================================================

    modifier onlyOwner() {
        require(msg.sender == owner, "DataVerifier: not owner");
        _;
    }

    // =========================================================================
    // Constructor
    // =========================================================================

    constructor() {
        owner = msg.sender;
        authorizedSigners[msg.sender] = true;
        emit SignerAuthorized(msg.sender);
    }

    // =========================================================================
    // Funcoes Principais
    // =========================================================================

    /**
     * @notice Armazena dados verificados on-chain.
     * @param dataHash Hash keccak256 dos dados originais
     * @param signature Assinatura ECDSA dos dados (65 bytes)
     *
     * @dev A funcao recupera o signer via ecrecover e verifica se
     *      esta na lista de authorizedSigners.
     */
    function storeData(
        bytes32 dataHash,
        bytes calldata signature
    ) external returns (bool) {
        require(!records[dataHash].exists, "DataVerifier: already exists");

        // Recupera o signer da assinatura
        address signer = _recoverSigner(dataHash, signature);
        require(authorizedSigners[signer], "DataVerifier: unauthorized signer");

        // Armazena
        records[dataHash] = DataRecord({
            dataHash: dataHash,
            signer: signer,
            timestamp: block.timestamp,
            exists: true
        });

        totalRecords++;
        emit DataStored(dataHash, signer, block.timestamp);

        return true;
    }

    /**
     * @notice Armazena dados com dados brutos (armazena hash).
     * @param data Dados brutos (qualquer tamanho)
     * @param signature Assinatura ECDSA
     */
    function storeRawData(
        bytes calldata data,
        bytes calldata signature
    ) external returns (bytes32) {
        bytes32 dataHash = keccak256(data);
        require(!records[dataHash].exists, "DataVerifier: already exists");

        address signer = _recoverSigner(dataHash, signature);
        require(authorizedSigners[signer], "DataVerifier: unauthorized signer");

        records[dataHash] = DataRecord({
            dataHash: dataHash,
            signer: signer,
            timestamp: block.timestamp,
            exists: true
        });

        totalRecords++;
        emit DataStored(dataHash, signer, block.timestamp);

        return dataHash;
    }

    // =========================================================================
    // Funcoes de Consulta
    // =========================================================================

    /**
     * @notice Verifica se um hash de dados existe e foi verificado.
     */
    function verify(bytes32 dataHash) external view returns (bool) {
        return records[dataHash].exists;
    }

    /**
     * @notice Obtem detalhes de um registro.
     */
    function getRecord(
        bytes32 dataHash
    ) external view returns (DataRecord memory) {
        require(records[dataHash].exists, "DataVerifier: not found");
        return records[dataHash];
    }

    /**
     * @notice Verifica se um endereco e signer autorizado.
     */
    function isAuthorizedSigner(address signer) external view returns (bool) {
        return authorizedSigners[signer];
    }

    // =========================================================================
    // Funcoes de Administracao
    // =========================================================================

    /**
     * @notice Adiciona um signer autorizado.
     */
    function authorizeSigner(address signer) external onlyOwner {
        require(signer != address(0), "DataVerifier: zero address");
        require(!authorizedSigners[signer], "DataVerifier: already authorized");

        authorizedSigners[signer] = true;
        emit SignerAuthorized(signer);
    }

    /**
     * @notice Remove um signer autorizado.
     */
    function revokeSigner(address signer) external onlyOwner {
        require(authorizedSigners[signer], "DataVerifier: not authorized");
        require(signer != owner, "DataVerifier: cannot revoke owner");

        authorizedSigners[signer] = false;
        emit SignerRevoked(signer);
    }

    /**
     * @notice Transfere ownership do contrato.
     */
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "DataVerifier: zero address");

        // Owner atual continua como signer
        address oldOwner = owner;
        owner = newOwner;
        authorizedSigners[newOwner] = true;

        emit OwnershipTransferred(oldOwner, newOwner);
        emit SignerAuthorized(newOwner);
    }

    // =========================================================================
    // Funcoes Internas
    // =========================================================================

    /**
     * @notice Recupera o endereco do signer a partir de um hash e assinatura.
     * @dev Usa ecrecover do Ethereum para verificacao ECDSA.
     */
    function _recoverSigner(
        bytes32 dataHash,
        bytes calldata signature
    ) internal pure returns (address) {
        require(signature.length == 65, "DataVerifier: invalid signature length");

        bytes32 r;
        bytes32 s;
        uint8 v;

        // Extrai r, s, v da assinatura
        assembly {
            r := calldataload(signature.offset)
            s := calldataload(add(signature.offset, 0x20))
            v := byte(0, calldataload(add(signature.offset, 0x40)))
        }

        // Ajusta v (EIP-155)
        if (v < 27) {
            v += 27;
        }

        // Prepara o hash para ecrecover (prefixo Ethereum)
        bytes32 ethSignedHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash)
        );

        return ecrecover(ethSignedHash, v, r, s);
    }
}
