# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a Hardhat Ignition module that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/deploy.ts
```

# PopeAuctionHouse Contract Interaction Guide

This guide provides an overview of how to interact with the `PopeAuctionHouse` contract, as well as the associated `ERC721Token` and `PopeToken` contracts. The contracts were authored by Ekarika Nsemeke.

## ERC721Token Contract

This contract is an ERC721 token with additional functionality. It allows for the minting of new tokens and the approval of spenders.

### Minting a new token

To mint a new token, call the `mint` function. This function increments the current token ID, mints a new token, assigns it to the caller, and sets its token URI.

```javascript
ERC721TokenContract.methods.mint().send({ from: userAddress });
```

### Approving a spender

To approve a spender for a token, call the approveSpender function with the address of the spender and the token ID.

```javascript
ERC721TokenContract.methods.approveSpender(spenderAddress, tokenId).send({ from: userAddress });
```

## PopeToken Contract

This contract is an ERC20 token with additional functionality. It allows for the approval of spenders, transfer of tokens, and burning of tokens.

### Approving a spender

To approve a spender, call the approve function with the address of the spender and the amount to approve.

```javascript
PopeTokenContract.methods.approve(spenderAddress, amount).send({ from: userAddress });
```

### Transferring tokens

To transfer tokens, call the transfer function with the recipient's address and the amount to transfer.

```javascript
PopeTokenContract.methods.transfer(recipientAddress, amount).send({ from: userAddress });
```

### Burning tokens
To burn tokens, call the burn function with the amount to burn.

```javascript
PopeTokenContract.methods.burn(amount).send({ from: userAddress });
```

## PopeAuctionHouse Contract
This contract allows for the creation of auctions, bidding on auctions, and ending auctions.

### Creating an auction

To create an auction, call the createAuction function with the token ID, whether the token is ERC1155, the amount, and the NFT contract address.

```javascript
PopeAuctionHouseContract.methods.createAuction(tokenId, isERC1155, amount, nftContractAddress).send({ from: userAddress });
```

### Bidding on an auction
To bid on an auction, call the bid function with the token ID and the bid amount.

```javascript
PopeAuctionHouseContract.methods.bid(tokenId, bidAmount).send({ from: userAddress });
```

### Ending an auction
To end an auction, call the endAuction function with the token ID and the NFT contract address.

```javascript
PopeAuctionHouseContract.methods.endAuction(tokenId, nftContractAddress).send({ from: userAddress });
```
Please note that only the seller can end an auction.