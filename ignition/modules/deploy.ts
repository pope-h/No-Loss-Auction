import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const JAN_1ST_2030 = 1893456000;
const ONE_MILLION_TOKEN: bigint = 1_000_000n;

const PopeAuctionHouseModule = buildModule("PopeAuctionHouseModule", (m) => {
  const initialSupply = m.getParameter("initialSupply", ONE_MILLION_TOKEN);

  const popeToken = m.contract("PopeToken", [initialSupply]);
  const popeAuctionHouse = m.contract("PopeAuctionHouse", [popeToken]);
  const erc721Token = m.contract("ERC721Token");

  return { popeToken, popeAuctionHouse, erc721Token };
});

export default PopeAuctionHouseModule;
