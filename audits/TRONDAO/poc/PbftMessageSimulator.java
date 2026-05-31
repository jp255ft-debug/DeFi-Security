import java.util.Random;

/**
 * Simulador de mensagens PBFT para o TRON java-tron.
 * Cada instância desta classe representa uma thread que envia
 * mensagens PREPARE e COMMIT para um bloco malicioso, tentando
 * acionar a condição de corrida no PbftMessageHandle.remove().
 * 
 * Alvo: PbftMessageHandle.java:291 — wait(100) dentro de synchronized
 * Programa: TRON DAO — HackerOne (US$ 100.000)
 */
public class PbftMessageSimulator extends Thread {
    private final String nodeAddress;       // Endereço do nó TRON local
    private final int nodePort;             // Porta gRPC do nó
    private final String maliciousBlockNo;  // Número do bloco malicioso (B')
    private final int threadId;
    private volatile boolean running = true;
    private volatile boolean forkDetected = false;

    public PbftMessageSimulator(String nodeAddress, int nodePort, 
                                String maliciousBlockNo, int threadId) {
        this.nodeAddress = nodeAddress;
        this.nodePort = nodePort;
        this.maliciousBlockNo = maliciousBlockNo;
        this.threadId = threadId;
        System.out.println("[Thread " + threadId + "] Inicializada para bloco " + maliciousBlockNo);
    }

    @Override
    public void run() {
        Random random = new Random();
        int iterations = 0;
        
        while (running && !forkDetected) {
            try {
                iterations++;
                
                // 1. Enviar PREPARE para o bloco malicioso
                sendPrepareMessage(maliciousBlockNo);
                Thread.sleep(random.nextInt(5) + 1); // 1-5ms delay
                
                // 2. Enviar COMMIT para o bloco malicioso
                sendCommitMessage(maliciousBlockNo);
                Thread.sleep(random.nextInt(5) + 1);
                
                // 3. Simular chamada ao remove() com wait(100)
                //    Esta é a janela onde a race condition ocorre
                simulateRemoveWithWait(maliciousBlockNo);
                
                if (iterations % 100 == 0) {
                    System.out.println("[Thread " + threadId + "] " + iterations + " iteracoes concluidas");
                }
                
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                break;
            } catch (Exception e) {
                System.err.println("[Thread " + threadId + "] Erro: " + e.getMessage());
            }
        }
        
        System.out.println("[Thread " + threadId + "] Finalizada apos " + iterations + " iteracoes");
    }

    /**
     * Simula o envio de uma mensagem PREPARE para o no TRON.
     * No ambiente real, usaria gRPC para chamar o metodo onPrepare().
     */
    private void sendPrepareMessage(String blockNo) {
        try {
            System.out.println("[Thread " + threadId + "] PREPARE enviado para " + blockNo);
        } catch (Exception e) {
            System.err.println("[Thread " + threadId + "] Erro ao enviar PREPARE: " + e.getMessage());
        }
    }

    /**
     * Simula o envio de uma mensagem COMMIT para o no TRON.
     */
    private void sendCommitMessage(String blockNo) {
        try {
            System.out.println("[Thread " + threadId + "] COMMIT enviado para " + blockNo);
        } catch (Exception e) {
            System.err.println("[Thread " + threadId + "] Erro ao enviar COMMIT: " + e.getMessage());
        }
    }

    /**
     * Simula a chamada ao metodo remove() com wait(100).
     * O wait(100) libera o monitor do objeto synchronized, permitindo
     * que outras threads modifiquem srPbftMessage durante a janela.
     * 
     * Cenario explorado:
     * - Thread A entra em remove(), chama wait(100), libera lock
     * - Thread B modifica srPbftMessage durante a janela
     * - Thread A retorna do wait() e chama onPrePrepare() com estado inconsistente
     */
    private void simulateRemoveWithWait(String blockNo) throws InterruptedException {
        synchronized (this) {
            System.out.println("[Thread " + threadId + "] remove() iniciado para " + blockNo);
            
            System.out.println("[Thread " + threadId + "] wait(100) - JANELA DE RACE CONDITION");
            wait(100); // Libera o lock temporariamente — spurious wakeup possivel
            
            System.out.println("[Thread " + threadId + "] wait(100) retornou - POSSIVEL SPURIOUS WAKEUP");
        }
    }

    public void stopRunning() {
        this.running = false;
    }

    public void signalForkDetected() {
        this.forkDetected = true;
    }
}
