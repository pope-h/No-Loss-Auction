// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "./interfaces/IERC165.sol";
import "./interfaces/IERC20.sol";
import {PopeToken} from "./PopeToken.sol";

contract PopeAuctionHouse {
    struct Auction {
        address seller;
        uint256 tokenId;
        address highestBidder;
        uint256 highestBid;
        uint256 prevBid;
        bool ended;
        bool isERC1155;
        uint256 amount; // For ERC1155 tokens
    }

    IERC20 popeTokenAddr;
    mapping(uint256 => Auction) auctions;
    address teamWallet;
    uint256 public constant FEE_DENOMINATOR = 100;
    address public constant DAO_ADDRESS = 0xb7B943fFbA78e33589971e630AD6EB544252D88C;

    event AuctionCreated(uint256 indexed tokenId, bool isERC1155, uint256 amount);
    event NewBid(uint256 indexed tokenId, address bidder, uint256 bid);
    event AuctionEnded(uint256 indexed tokenId, address winner, uint256 bid);
    event FeesDistributed(uint256 indexed tokenId, uint256 prevBidderProfit, uint256 feesBurned, uint256 feesToDAO, uint256 feesToTeam);

    constructor(address _popeTokenAddress) {
        popeTokenAddr = IERC20(_popeTokenAddress);
        teamWallet = address(this);
    }

    function createAuction(uint256 _tokenId, bool _isERC1155, uint256 _amount, address _nftContract) external {
        require(!auctions[_tokenId].ended, "Auction already exists");
        require(_nftContract != address(0), "Invalid Contract Address");
        require(
            IERC721(_nftContract).ownerOf(_tokenId) == msg.sender,
            "Not Owner"
        );

        IERC721(_nftContract).transferFrom(msg.sender, address(this), _tokenId);

        auctions[_tokenId] = Auction({
            seller: msg.sender,
            tokenId: _tokenId,
            highestBidder: address(0),
            highestBid: _amount,
            prevBid: 0,
            ended: false,
            isERC1155: _isERC1155,
            amount: _amount
        });

        emit AuctionCreated(_tokenId, _isERC1155, _amount);
    }

    function bid(uint256 _tokenId, uint256 _bidAmount) external {
        Auction storage auction = auctions[_tokenId];
        require(!auction.ended, "Auction end already called");
        require(_bidAmount > auction.highestBid, "There already is a higher bid");

        if (auction.highestBidder == address(0)) {
            popeTokenAddr.transferFrom(msg.sender, address(this), _bidAmount);
            auction.highestBid = _bidAmount;
            auction.prevBid = _bidAmount;
            auction.highestBidder = msg.sender;
            return;
        }

        popeTokenAddr.transferFrom(msg.sender, address(this), _bidAmount);

        distributeFees(_tokenId, _bidAmount);

        auction.highestBidder = msg.sender;
        auction.prevBid = _bidAmount;

        emit NewBid(_tokenId, msg.sender, _bidAmount);
    }

    function onlySeller(uint256 _tokenId) internal view {
        require(auctions[_tokenId].seller == msg.sender, "Not Seller");
    }

    function endAuction(uint256 _tokenId, address _nftContract) external {
        onlySeller(_tokenId);
        // In future implementation, the contract should self terminate on time-out
        Auction storage auction = auctions[_tokenId];
        require(!auction.ended, "Auction end already called");

        // The below commented out in case the seller is satisfied with the price
        // require(block.timestamp >= auction.endTime, "Auction not yet ended");

        auction.ended = true;
        if (auction.highestBidder != address(0)) {
            // Transfer the token to the highest bidder
            if (auction.isERC1155) {
                IERC1155(_nftContract).safeTransferFrom(address(this), auction.highestBidder, auction.tokenId, auction.amount, "");
            } else {
                IERC721(_nftContract).safeTransferFrom(address(this), auction.highestBidder, auction.tokenId);
            }
            // Transfer the highest bid to the seller
            popeTokenAddr.transfer(auction.seller, auction.highestBid);
        } else {
            if (auction.isERC1155) {
                IERC1155(_nftContract).safeTransferFrom(address(this), auction.seller, auction.tokenId, auction.amount, "");
            } else {
                IERC721(_nftContract).safeTransferFrom(address(this), auction.seller, auction.tokenId);
            }
        }

        emit AuctionEnded(_tokenId, auction.highestBidder, auction.highestBid);
    }

     // Function to distribute fees
    function distributeFees(uint256 _tokenId, uint256 _bidAmount) internal returns(uint256) {
        Auction storage auction = auctions[_tokenId];
        uint256 totalFee = _bidAmount * 10 / FEE_DENOMINATOR;
        auction.highestBid = _bidAmount - totalFee;
        uint256 prevBidderProfit = totalFee * 30 / FEE_DENOMINATOR;
        uint256 burnAmount = totalFee * 20 / FEE_DENOMINATOR;
        uint256 daoAmount = totalFee * 30 / FEE_DENOMINATOR;
        uint256 teamAmount = totalFee * 20 / FEE_DENOMINATOR;

        uint256 totalRefund = auction.prevBid + prevBidderProfit;
        // return prev.Bid to auction.highestBid as it is the prev highest bidder as of now
        popeTokenAddr.transferFrom(address(this), auction.highestBidder, totalRefund);

        // Burn the tokens
        popeTokenAddr.burn(burnAmount);

        // Send fee to DAO (random DAO address logic to be implemented)
        popeTokenAddr.transfer(DAO_ADDRESS, daoAmount);

        // Send fee to team wallet
        popeTokenAddr.transfer(teamWallet, teamAmount);

        emit FeesDistributed(_tokenId, prevBidderProfit, burnAmount, daoAmount, teamAmount);

        return prevBidderProfit;
    }
}