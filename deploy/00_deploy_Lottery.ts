import { DeployFunction } from 'hardhat-deploy/types'
import { HardhatRuntimeEnvironment } from 'hardhat/types'
import { developmentChains } from '../helper-hardhat-config'
import verify from '../utils/verify'

const deployContract: DeployFunction = async function (
    hre: HardhatRuntimeEnvironment
) {
    const { getNamedAccounts, deployments, network } = hre
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()

    const contract = await deploy('Lottery', {
        from: deployer,
        args: [],
        log: true
    })
    log(`Lottery deployed at ${contract.address} from deployer ${deployer}`)
    if (
        !developmentChains.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        await verify(contract.address, [])
    }
}
export default deployContract
deployContract.tags = ['all', 'lottery']
