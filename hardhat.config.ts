import '@nomicfoundation/hardhat-toolbox'
import '@nomiclabs/hardhat-solhint'
import 'dotenv/config'
import 'hardhat-deploy'
import { HardhatUserConfig } from 'hardhat/config'

const COINMARKETCAP_API_KEY = process.env.COINMARKETCAP_API_KEY || ''
const RINKEBY_RPC_URL =
    process.env.RINKEBY_RPC_URL ||
    'https://eth-mainnet.alchemyapi.io/v2/your-api-key'
const PRIVATE_KEY =
    process.env.PRIVATE_KEY ||
    '0x11ee3108a03081fe260ecdc106554d09d9d1209bcafd46942b10e02943effc4a'
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || ''

const config: HardhatUserConfig = {
    defaultNetwork: 'hardhat',
    networks: {
        hardhat: {
            chainId: 31337
        },
        rinkeby: {
            url: RINKEBY_RPC_URL,
            accounts: [PRIVATE_KEY],
            chainId: 4
        }
    },
    solidity: {
        compilers: [
            {
                version: '0.8.16'
            },
            {
                version: '0.8.9'
            },
            {
                version: '0.6.6'
            }
        ]
    },
    etherscan: {
        apiKey: ETHERSCAN_API_KEY
    },
    gasReporter: {
        enabled: true,
        currency: 'USD',
        outputFile: 'gas-report.txt',
        noColors: true,
        coinmarketcap: COINMARKETCAP_API_KEY
    },
    namedAccounts: {
        deployer: {
            default: 0,
            1: 0
        }
    }
}

export default config
