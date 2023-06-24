import "@matterlabs/hardhat-zksync-deploy";
import "@matterlabs/hardhat-zksync-solc";
import "@matterlabs/hardhat-zksync-verify";

module.exports = {
  zksolc: {
    version: "1.3.10",
    compilerSource: "binary",
    settings: {},
  },
  defaultNetwork: "zkSyncTestnet",

  networks: {
    zkSyncTestnet: {
      url: "https://testnet.era.zksync.dev",
      zksync: true,
      verifyURL: 'https://zksync2-testnet-explorer.zksync.dev/contract_verification'  // Verification endpoint
    },
  },
  solidity: {
    version: "0.8.18",
  },
};
