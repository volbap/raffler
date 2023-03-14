const { network } = require("hardhat")
const { developmentChains } = require("../helper-hardhat-config")

const DECIMALS = "18"
const INITIAL_PRICE = "200000000000000000000"
const BASE_FEE = "250000000000000000"
const GAS_PRICE_LINK = 1e9

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    if (developmentChains.includes(network.name)) {
        log("🪂 Deploying mocks...")

        await deploy("VRFCoordinatorV2Mock", {
            from: deployer,
            log: true,
            args: [BASE_FEE, GAS_PRICE_LINK],
        })

        await deploy("MockV3Aggregator", {
            from: deployer,
            log: true,
            args: [DECIMALS, INITIAL_PRICE],
        })

        await deploy("LinkTokenMock", {
            from: deployer,
            log: true,
            args: [10000000000],
        })

        await deploy("RaffleToken", { from: deployer, log: true, args: [1_000_000_000000] })

        const linkToken = await ethers.getContract("LinkTokenMock")
        const mockV3Aggregator = await ethers.getContract("MockV3Aggregator")
        const vrfCoordinatorV2Mock = await ethers.getContract("VRFCoordinatorV2Mock")

        await deploy("VRFV2Wrapper", {
            from: deployer,
            log: true,
            args: [linkToken.address, mockV3Aggregator.address, vrfCoordinatorV2Mock.address],
        })

        log("Mocks Deployed!")
        log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        log("You are deploying to a local network, you'll need a local network running to interact")
        log(
            "Please run `yarn hardhat console --network localhost` to interact with the deployed smart contracts!"
        )
        log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    }
}
module.exports.tags = ["all", "mocks", "main"]
