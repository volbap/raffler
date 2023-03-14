const { network, ethers } = require("hardhat")
const { developmentChains, networkConfig } = require("../helper-hardhat-config")
const { verify } = require("../utils/verify")

module.exports = async function (hre) {
    const { getNamedAccounts, deployments } = hre
    const { deploy, log } = deployments
    const { deployer, beneficiary } = await getNamedAccounts()
    const chainId = network.config.chainId

    // Parameters that depend on the network:
    let raffleToken, linkToken, vrfV2Wrapper

    if (developmentChains.includes(network.name)) {
        // When in a local network, use deployed mocks addresses...
        raffleToken = (await ethers.getContract("RaffleToken")).address
        linkToken = (await ethers.getContract("LinkTokenMock")).address
        vrfV2Wrapper = (await ethers.getContract("VRFV2Wrapper")).address
    } else {
        // Otherwise, use network addresses...
        raffleToken = networkConfig[chainId]["usdcToken"]
        linkToken = networkConfig[chainId]["vrfLinkToken"]
        vrfV2Wrapper = networkConfig[chainId]["vrfV2Wrapper"]
    }

    // Fixed parameters:
    const ticketPrice = 2e6 // 2 whole tokens with 6 decimals (2_000_000)
    const ticketMinNumber = 1
    const ticketMaxNumber = 1
    const profitPercentage = 15

    const args = [
        raffleToken,
        ticketPrice,
        ticketMinNumber,
        ticketMaxNumber,
        profitPercentage,
        beneficiary,
        linkToken,
        vrfV2Wrapper,
    ]
    const raffle = await deploy("Raffle", {
        from: deployer,
        args: args,
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })

    if (!developmentChains.includes(network.name)) {
        await verify(raffle.address, args)
    }

    log("✅ Deploy done!")
}

module.exports.tags = ["all", "raffle"]
