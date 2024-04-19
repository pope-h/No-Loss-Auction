import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require("@bonadocs/docgen");
require("dotenv").config();

const { URL, PRIVATE_KEY, ETHERSCAN_API_KEY } = process.env;

module.exports = {
  solidity: "0.8.20",
  networks: {
    arbitrum: {
      url: URL,
      accounts: [`0x${PRIVATE_KEY}`],
    },
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  },
  docgen: {
    projectName: "No Loss Auction Protocol",
    projectDescription:
      "An awesome web3 auction protocol where outbidded investors do not lose their money.",
    outputDir: "./site",
    deploymentAddresses: {
      PopeAuctionHouse: [
        {
          chainId: 42161, // arbitrum
          address: "0xe8e3c345307b0462D8C1c361D10f62AbB6644392",
        },
      ],
      PopeToken: [
        {
          chainId: 42161, // arbitrum
          address: "0x94CDec01d256157E188eDc1328210841891E9281",
        },
      ],
      ERC721Token: [
        {
          chainId: 42161, // arbitrum
          address: "0xF2B690121D8caf1c28E182e8afe6D9967f4B2453",
        },
      ],
    },
  },
};

// 0xF9aa21D3921C7F292738D4E5864EaE3543081E98
// 0x93A74297cF5FB2E7e505f70141e0Af11d718cCde