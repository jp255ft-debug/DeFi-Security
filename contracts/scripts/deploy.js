const hre = require("hardhat");
const fs = require("fs");
const path = require("path");

async function main() {
  console.log("Iniciando o deploy dos contratos H2V-Trust...");

  // 1. Deploy do BatchRegistry
  console.log("Fazendo deploy do BatchRegistry...");
  const BatchRegistry = await hre.ethers.getContractFactory("BatchRegistry");
  const batchRegistry = await BatchRegistry.deploy();
  await batchRegistry.waitForDeployment();
  const batchRegistryAddress = await batchRegistry.getAddress();
  console.log(`✅ BatchRegistry implantado em: ${batchRegistryAddress}`);

  // 2. Deploy do ComplianceVerifier
  console.log("Fazendo deploy do ComplianceVerifier...");
  const ComplianceVerifier = await hre.ethers.getContractFactory("ComplianceVerifier");
  const complianceVerifier = await ComplianceVerifier.deploy(batchRegistryAddress);
  await complianceVerifier.waitForDeployment();
  const complianceVerifierAddress = await complianceVerifier.getAddress();
  console.log(`✅ ComplianceVerifier implantado em: ${complianceVerifierAddress}`);

  // 3. Deploy do DelegationManager
  console.log("Fazendo deploy do DelegationManager...");
  const DelegationManager = await hre.ethers.getContractFactory("DelegationManager");
  const delegationManager = await DelegationManager.deploy();
  await delegationManager.waitForDeployment();
  const delegationManagerAddress = await delegationManager.getAddress();
  console.log(`✅ DelegationManager implantado em: ${delegationManagerAddress}`);

  // 4. Deploy do GreenHydrogenSBT
  console.log("Fazendo deploy do GreenHydrogenSBT...");
  const GreenHydrogenSBT = await hre.ethers.getContractFactory("GreenHydrogenSBT");
  const sbt = await GreenHydrogenSBT.deploy(
    "Green Hydrogen Certificate",
    "GHCERT",
    batchRegistryAddress,
    complianceVerifierAddress
  );
  await sbt.waitForDeployment();
  const sbtAddress = await sbt.getAddress();
  console.log(`✅ GreenHydrogenSBT implantado em: ${sbtAddress}`);

  console.log("\nAtualizando arquivo .env na base do projeto...");
  const envPath = path.join(__dirname, "../../.env");
  
  if (fs.existsSync(envPath)) {
    let envContent = fs.readFileSync(envPath, "utf8");
    
    // Mapeamento de chaves do .env para endereços dos contratos
    const envUpdates = {
      "CONTRACT_ADDRESS": sbtAddress,
      "GREEN_HYDROGEN_SBT_ADDRESS": sbtAddress,
      "BATCH_REGISTRY_ADDRESS": batchRegistryAddress,
      "COMPLIANCE_VERIFIER_ADDRESS": complianceVerifierAddress,
      "DELEGATION_MANAGER_ADDRESS": delegationManagerAddress,
    };
    
    for (const [key, value] of Object.entries(envUpdates)) {
      const regex = new RegExp(`${key}=.*`, "g");
      if (envContent.includes(`${key}=`)) {
        envContent = envContent.replace(regex, `${key}=${value}`);
      } else {
        envContent += `\n${key}=${value}`;
      }
    }
    
    fs.writeFileSync(envPath, envContent);
    console.log("✅ Arquivo .env atualizado com sucesso!");
    console.log(`   CONTRACT_ADDRESS            = ${sbtAddress}`);
    console.log(`   GREEN_HYDROGEN_SBT_ADDRESS  = ${sbtAddress}`);
    console.log(`   BATCH_REGISTRY_ADDRESS      = ${batchRegistryAddress}`);
    console.log(`   COMPLIANCE_VERIFIER_ADDRESS = ${complianceVerifierAddress}`);
    console.log(`   DELEGATION_MANAGER_ADDRESS  = ${delegationManagerAddress}`);
  } else {
    console.warn("⚠️ Arquivo .env não encontrado na raiz. Os endereços devem ser inseridos manualmente.");
  }

  console.log("\n🎉 Deploy concluído com sucesso!");
  console.log("-----------------------------------------");
  console.log("BatchRegistry:      ", batchRegistryAddress);
  console.log("ComplianceVerifier: ", complianceVerifierAddress);
  console.log("DelegationManager:  ", delegationManagerAddress);
  console.log("GreenHydrogenSBT:   ", sbtAddress);
  console.log("-----------------------------------------");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
