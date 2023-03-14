require("@nomiclabs/hardhat-waffle")
require("@nomiclabs/hardhat-etherscan")
require("hardhat-deploy")
require("solidity-coverage")
require("hardhat-gas-reporter")
require("hardhat-contract-sizer")
require("@primitivefi/hardhat-dodoc")
require("dotenv").config()

module.exports = {
    solidity: "0.8.18",
    defaultNetwork: "hardhat",
    networks: {
        hardhat: {
            chainId: 31337,
            blockConfirmations: 1,
        },
        bscMainnet: {
            chainId: 56,
            blockConfirmations: 6,
            url: process.env.BSC_MAINNET_RPC_URL,
            accounts: [process.env.DEPLOYER_PRIVATE_KEY],
        },
        bscTestnet: {
            chainId: 97,
            blockConfirmations: 6,
            url: process.env.BSC_TESTNET_RPC_URL,
            accounts: [process.env.DEPLOYER_PRIVATE_KEY],
        },
    },
    namedAccounts: {
        deployer: { default: 0 },
        player1: { default: 1 },
        player2: { default: 2 },
        player3: { default: 3 },
        beneficiary: { default: 4 },
    },
    gasReporter: {
        enabled: false,
        currency: "USD",
        outputFile: "gas-report.txt",
        noColors: true,
        coinmarketcap: process.env.COINMARKETCAP_API_KEY,
    },
    mocha: {
        timeout: 200_000, // 200 seconds
    },
    etherscan: {
        apiKey: {
            bscMainnet: process.env.BSC_MAINNET_SCANNER_API_KEY,
            bscTestnet: process.env.BSC_TESTNET_SCANNER_API_KEY,
        },
    },
}
