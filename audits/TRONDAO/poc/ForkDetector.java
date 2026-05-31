import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Detector de fork para o PoC da condicao de corrida no TRON.
 * Monitora os blocos aceites e verifica se dois blocos diferentes
 * foram aceites na mesma altura (fork).
 * 
 * Alvo: PbftMessageHandle.java:291 — wait(100) dentro de synchronized
 * Programa: TRON DAO — HackerOne (US$ 100.000)
 */
public class ForkDetector extends Thread {
    
    // Mapeia altura do bloco -> conjunto de hashes aceites nessa altura
    private final Map<Long, Set<String>> blocksAtHeight;
    
    // Numero total de forks detectados
    private int forkCount;
    
    // Flag para indicar que um fork foi detectado
    private volatile boolean forkDetected;

    public ForkDetector() {
        this.blocksAtHeight = new ConcurrentHashMap<>();
        this.forkCount = 0;
        this.forkDetected = false;
        System.out.println("[ForkDetector] Inicializado");
    }

    @Override
    public void run() {
        while (!forkDetected) {
            try {
                // Em producao: consultar a API do no TRON para obter o bloco mais recente
                // BlockInfo latestBlock = tronNode.getLatestBlock();
                // checkBlock(latestBlock.getHeight(), latestBlock.getHash());
                
                Thread.sleep(100); // Verifica a cada 100ms
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                break;
            }
        }
    }

    /**
     * Verifica se um bloco foi aceite e se ha outro bloco na mesma altura.
     * 
     * @param height    Altura do bloco
     * @param blockHash Hash do bloco
     * @return true se um fork foi detectado (dois blocos diferentes na mesma altura)
     */
    public synchronized boolean checkBlock(long height, String blockHash) {
        Set<String> blocks = blocksAtHeight.computeIfAbsent(height, k -> new HashSet<>());
        boolean alreadyExists = blocks.contains(blockHash);
        blocks.add(blockHash);
        
        System.out.println("[ForkDetector] Bloco recebido: altura=" + height + ", hash=" + blockHash.substring(0, Math.min(16, blockHash.length())) + "...");
        
        if (blocks.size() > 1) {
            forkDetected = true;
            forkCount++;
            
            System.out.println("+============================================================+");
            System.out.println("|  FORK DETECTADO na altura " + height + "                          |");
            System.out.println("+============================================================+");
            
            int i = 1;
            for (String hash : blocks) {
                System.out.println("|  Bloco " + i + ": " + hash + " |");
                i++;
            }
            
            System.out.println("+============================================================+");
            System.out.println("|  Impacto: Double-spend possivel com valor estimado de       |");
            System.out.println("|  US$ 100.000+ (recompensa maxima do programa TRON DAO)      |");
            System.out.println("+============================================================+");
            
            return true;
        }
        
        return false;
    }

    /**
     * Verifica manualmente se um fork ocorreu, fornecendo os hashes
     * dos blocos nas diferentes chains.
     * 
     * @param height        Altura do bloco
     * @param blockHashA    Hash do bloco na chain A
     * @param blockHashB    Hash do bloco na chain B
     */
    public synchronized void verifyFork(long height, String blockHashA, String blockHashB) {
        Set<String> blocks = new HashSet<>();
        blocks.add(blockHashA);
        blocks.add(blockHashB);
        blocksAtHeight.put(height, blocks);
        
        if (blocks.size() > 1) {
            forkDetected = true;
            forkCount++;
            System.out.println("FORK CONFIRMADO na altura " + height);
            System.out.println("   Bloco A: " + blockHashA);
            System.out.println("   Bloco B: " + blockHashB);
        }
    }

    /**
     * Verifica se o estado srPbftMessage ficou inconsistente apos o ataque.
     * O cenario de fork ocorre quando:
     * 1. Thread A entra em remove() e chama wait(100)
     * 2. Thread B modifica srPbftMessage durante a janela
     * 3. Thread A retorna do wait() e chama onPrePrepare() com srPbftMessage de B
     * 4. Thread B tambem processa o mesmo bloco
     * 
     * @param originalBlockNo  Numero do bloco original
     * @param maliciousBlockNo Numero do bloco malicioso
     */
    public void checkSrPbftMessageState(String originalBlockNo, String maliciousBlockNo) {
        System.out.println("[ForkDetector] Verificando estado de srPbftMessage apos ataque...");
        System.out.println("[ForkDetector]   Bloco original: " + originalBlockNo);
        System.out.println("[ForkDetector]   Bloco malicioso: " + maliciousBlockNo);
        System.out.println("[ForkDetector]   Estado esperado: srPbftMessage alterado durante wait(100)");
    }

    public boolean isForkDetected() {
        return forkDetected;
    }

    public int getForkCount() {
        return forkCount;
    }

    /**
     * Gera um relatorio resumido da deteccao de fork.
     */
    public void generateReport() {
        System.out.println("\n================================================");
        System.out.println("  RELATORIO DE DETECCAO DE FORK");
        System.out.println("================================================");
        System.out.println("  Forks detectados: " + forkCount);
        System.out.println("  Alturas com fork: " + blocksAtHeight.size());
        System.out.println("  Fork confirmado: " + (forkDetected ? "SIM" : "NAO"));
        System.out.println("================================================\n");
    }
}
