// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title OracleDepin
 * @notice Oracle descentralizado para dados DePIN com sistema de
 *         disputas (optimistic oracle).
 *
 * @dev Qualquer signer autorizado pode propor dados. Ha um periodo
 *      de desafio (challenge period) onde qualquer um pode disputar
 *      os dados. Se nao houver disputa, os dados sao aceitos.
 *
 * Fluxo:
 *   1. Proposer envia dados assinados
 *   2. Inicia challenge period (ex: 1 hora)
 *   3. Se ninguem desafiar, dados sao finalizados
 *   4. Se houver desafio, entra em arbitragem
 */
contract OracleDepin {
    // =========================================================================
    // Tipos
    // =========================================================================

    enum ProposalStatus {
        Pending,    // Aguardando challenge period
        Accepted,   // Finalizado sem disputa
        Disputed,   // Em disputa
        Rejected    // Rejeitado apos disputa
    }

    struct DataProposal {
        bytes32 dataHash;
        address proposer;
        uint256 timestamp;
        uint256 challengeEnd;
        ProposalStatus status;
        string metadata; // URI com dados completos (IPFS/Arweave)
    }

    struct Dispute {
        address disputer;
        uint256 timestamp;
        string reason;
    }

    // =========================================================================
    // Variaveis de Estado
    // =========================================================================

    /// @notice Propostas por hash
    mapping(bytes32 => DataProposal) public proposals;

    /// @notice Disputas por proposta
    mapping(bytes32 => Dispute) public disputes;

    /// @notice Signers autorizados a propor dados
    mapping(address => bool) public authorizedProposers;

    /// @notice Arbitros autorizados a resolver disputas
    mapping(address => bool) public arbiters;

    /// @notice Owner do contrato
    address public owner;

    /// @notice Periodo de desafio em segundos (default: 1 hora)
    uint256 public challengePeriod;

    /// @notice Taxa para disputar (evita spam)
    uint256 public disputeFee;

    /// @notice Total de propostas
    uint256 public totalProposals;

    // =========================================================================
    // Eventos
    // =========================================================================

    event DataProposed(
        bytes32 indexed dataHash,
        address indexed proposer,
        uint256 challengeEnd
    );

    event DataAccepted(bytes32 indexed dataHash);
    event DataDisputed(
        bytes32 indexed dataHash,
        address indexed disputer,
        string reason
    );
    event DataRejected(bytes32 indexed dataHash);
    event DisputeResolved(bytes32 indexed dataHash, bool accepted);
    event ProposerAuthorized(address indexed proposer);
    event ProposerRevoked(address indexed proposer);
    event ArbiterAuthorized(address indexed arbiter);
    event ArbiterRevoked(address indexed arbiter);
    event ChallengePeriodUpdated(uint256 newPeriod);
    event DisputeFeeUpdated(uint256 newFee);

    // =========================================================================
    // Modifiers
    // =========================================================================

    modifier onlyOwner() {
        require(msg.sender == owner, "OracleDepin: not owner");
        _;
    }

    modifier onlyArbiter() {
        require(arbiters[msg.sender], "OracleDepin: not arbiter");
        _;
    }

    // =========================================================================
    // Constructor
    // =========================================================================

    constructor(uint256 _challengePeriod, uint256 _disputeFee) {
        owner = msg.sender;
        challengePeriod = _challengePeriod;
        disputeFee = _disputeFee;
        authorizedProposers[msg.sender] = true;
        arbiters[msg.sender] = true;
    }

    // =========================================================================
    // Funcoes Principais
    // =========================================================================

    /**
     * @notice Propoe novos dados DePIN.
     * @param dataHash Hash keccak256 dos dados
     * @param signature Assinatura ECDSA
     * @param metadata URI com dados completos (IPFS/Arweave)
     */
    function proposeData(
        bytes32 dataHash,
        bytes calldata signature,
        string calldata metadata
    ) external returns (bool) {
        require(
            proposals[dataHash].status == ProposalStatus.Pending ||
            proposals[dataHash].status == ProposalStatus.Accepted ||
            proposals[dataHash].status == ProposalStatus.Rejected,
            "OracleDepin: already proposed"
        );

        // Se ja existe e foi aceito/rejeitado, nao permite repropor
        if (proposals[dataHash].status == ProposalStatus.Accepted ||
            proposals[dataHash].status == ProposalStatus.Rejected) {
            revert("OracleDepin: already finalized");
        }

        // Verifica signer
        address signer = _recoverSigner(dataHash, signature);
        require(
            authorizedProposers[signer],
            "OracleDepin: unauthorized proposer"
        );

        proposals[dataHash] = DataProposal({
            dataHash: dataHash,
            proposer: signer,
            timestamp: block.timestamp,
            challengeEnd: block.timestamp + challengePeriod,
            status: ProposalStatus.Pending,
            metadata: metadata
        });

        totalProposals++;
        emit DataProposed(dataHash, signer, block.timestamp + challengePeriod);

        return true;
    }

    /**
     * @notice Finaliza uma proposta apos challenge period.
     */
    function acceptData(bytes32 dataHash) external {
        DataProposal storage proposal = proposals[dataHash];
        require(
            proposal.status == ProposalStatus.Pending,
            "OracleDepin: not pending"
        );
        require(
            block.timestamp >= proposal.challengeEnd,
            "OracleDepin: challenge period not ended"
        );

        proposal.status = ProposalStatus.Accepted;
        emit DataAccepted(dataHash);
    }

    /**
     * @notice Disputa uma proposta (paga taxa).
     */
    function disputeData(
        bytes32 dataHash,
        string calldata reason
    ) external payable {
        DataProposal storage proposal = proposals[dataHash];
        require(
            proposal.status == ProposalStatus.Pending,
            "OracleDepin: not pending"
        );
        require(
            block.timestamp < proposal.challengeEnd,
            "OracleDepin: challenge period ended"
        );
        require(msg.value >= disputeFee, "OracleDepin: insufficient fee");
        require(
            disputes[dataHash].timestamp == 0,
            "OracleDepin: already disputed"
        );

        proposal.status = ProposalStatus.Disputed;
        disputes[dataHash] = Dispute({
            disputer: msg.sender,
            timestamp: block.timestamp,
            reason: reason
        });

        emit DataDisputed(dataHash, msg.sender, reason);
    }

    /**
     * @notice Resolve uma disputa (apenas arbiter).
     */
    function resolveDispute(
        bytes32 dataHash,
        bool acceptData_
    ) external onlyArbiter {
        DataProposal storage proposal = proposals[dataHash];
        require(
            proposal.status == ProposalStatus.Disputed,
            "OracleDepin: not disputed"
        );

        if (acceptData_) {
            proposal.status = ProposalStatus.Accepted;
            // Devolve taxa ao disputer
            payable(disputes[dataHash].disputer).transfer(disputeFee);
        } else {
            proposal.status = ProposalStatus.Rejected;
            // Queima a taxa (ou envia ao owner)
            payable(owner).transfer(disputeFee);
        }

        emit DisputeResolved(dataHash, acceptData_);
    }

    // =========================================================================
    // Funcoes de Consulta
    // =========================================================================

    function getProposal(
        bytes32 dataHash
    ) external view returns (DataProposal memory) {
        return proposals[dataHash];
    }

    function getDispute(
        bytes32 dataHash
    ) external view returns (Dispute memory) {
        return disputes[dataHash];
    }

    function canChallengeEnd(bytes32 dataHash) external view returns (bool) {
        return
            proposals[dataHash].status == ProposalStatus.Pending &&
            block.timestamp >= proposals[dataHash].challengeEnd;
    }

    // =========================================================================
    // Administracao
    // =========================================================================

    function authorizeProposer(address proposer) external onlyOwner {
        authorizedProposers[proposer] = true;
        emit ProposerAuthorized(proposer);
    }

    function revokeProposer(address proposer) external onlyOwner {
        authorizedProposers[proposer] = false;
        emit ProposerRevoked(proposer);
    }

    function authorizeArbiter(address arbiter) external onlyOwner {
        arbiters[arbiter] = true;
        emit ArbiterAuthorized(arbiter);
    }

    function revokeArbiter(address arbiter) external onlyOwner {
        arbiters[arbiter] = false;
        emit ArbiterRevoked(arbiter);
    }

    function setChallengePeriod(uint256 newPeriod) external onlyOwner {
        challengePeriod = newPeriod;
        emit ChallengePeriodUpdated(newPeriod);
    }

    function setDisputeFee(uint256 newFee) external onlyOwner {
        disputeFee = newFee;
        emit DisputeFeeUpdated(newFee);
    }

    // =========================================================================
    // Internals
    // =========================================================================

    function _recoverSigner(
        bytes32 dataHash,
        bytes calldata signature
    ) internal pure returns (address) {
        require(signature.length == 65, "OracleDepin: invalid signature");

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            r := calldataload(signature.offset)
            s := calldataload(add(signature.offset, 0x20))
            v := byte(0, calldataload(add(signature.offset, 0x40)))
        }

        if (v < 27) {
            v += 27;
        }

        bytes32 ethSignedHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash)
        );

        return ecrecover(ethSignedHash, v, r, s);
    }
}
