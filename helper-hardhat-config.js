const networkConfig = {
    31337: {
        name: "hardhat",
        vrfCallbackGasLimit: "500000",
    },
    56: {
        name: "bscMainnet",
        usdcToken: "0x8ac76a51cc950d9822d68b83fe1ad97b32cd580d",
        vrfLinkToken: "0x404460C6A5EdE2D891e8297795264fDe62ADBB75",
        vrfV2Wrapper: "0x721DFbc5Cfe53d32ab00A9bdFa605d3b8E1f3f42",
        vrfCallbackGasLimit: "500000",
    },
    97: {
        name: "bscTestnet",
        usdcToken: "0x64544969ed7ebf5f083679233325356ebe738930",
        vrfLinkToken: "0x84b9B910527Ad5C03A9Ca831909E21e236EA7b06",
        vrfV2Wrapper: "0x699d428ee890d55D56d5FC6e26290f3247A762bd",
        vrfCallbackGasLimit: "500000",
    },
}

const developmentChains = ["hardhat", "localhost"]

module.exports = {
    networkConfig,
    developmentChains,
}
