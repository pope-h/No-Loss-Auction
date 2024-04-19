﻿## PopeAuctionHouse


### Auction

```solidity
struct Auction {
  address seller;
  uint256 tokenId;
  address highestBidder;
  uint256 highestBid;
  uint256 prevBid;
  bool ended;
  bool isERC1155;
  uint256 amount;
}
```
### popeTokenAddr

```solidity
contract IERC20 popeTokenAddr
```

### auctions

```solidity
mapping(uint256 => struct PopeAuctionHouse.Auction) auctions
```

### teamWallet

```solidity
address teamWallet
```

### FEE_DENOMINATOR

```solidity
uint256 FEE_DENOMINATOR
```

### DAO_ADDRESS

```solidity
address DAO_ADDRESS
```

### AuctionCreated

```solidity
event AuctionCreated(uint256 tokenId, bool isERC1155, uint256 amount)
```

### NewBid

```solidity
event NewBid(uint256 tokenId, address bidder, uint256 bid)
```

### AuctionEnded

```solidity
event AuctionEnded(uint256 tokenId, address winner, uint256 bid)
```

### FeesDistributed

```solidity
event FeesDistributed(uint256 tokenId, uint256 prevBidderProfit, uint256 feesBurned, uint256 feesToDAO, uint256 feesToTeam)
```

### constructor

```solidity
constructor(address _popeTokenAddress) public
```







### createAuction

<BonadocsWidget widgetConfigUri="ipfs://bafkreibhrboumx4hwmeh5qk2vq3jzb3b6n3i6pb7l4kgp7xmbl3asospd4" contract="PopeAuctionHouse" functionKey="0xb63a8151" />







### bid

<BonadocsWidget widgetConfigUri="ipfs://bafkreibhrboumx4hwmeh5qk2vq3jzb3b6n3i6pb7l4kgp7xmbl3asospd4" contract="PopeAuctionHouse" functionKey="0x598647f8" />







### onlySeller

```solidity
function onlySeller(uint256 _tokenId) internal view
```







### endAuction

<BonadocsWidget widgetConfigUri="ipfs://bafkreibhrboumx4hwmeh5qk2vq3jzb3b6n3i6pb7l4kgp7xmbl3asospd4" contract="PopeAuctionHouse" functionKey="0xcbf8455d" />







### distributeFees

```solidity
function distributeFees(uint256 _tokenId, uint256 _bidAmount) internal returns (uint256)
```







