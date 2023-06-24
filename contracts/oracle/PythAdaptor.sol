// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "../compound/EIP20Interface.sol";
import "../Ownable.sol";
import "@pythnetwork/pyth-sdk-solidity/IPyth.sol";

interface cTokenInterface {
    function underlying() external view returns (address);
}

contract PythAdaptor is Ownable {
    IPyth public pythMain;

    mapping(address => bytes32) public tokenFeeds;

    constructor(address _pythMain) {
        pythMain = IPyth(_pythMain);
    }

    function setTokenFeeds(address[] calldata tokens, bytes32[] calldata feeds) external onlyOwner {
        require(tokens.length == feeds.length, "Length mismatch");
        for (uint i = 0; i < tokens.length; i++) {
            tokenFeeds[tokens[i]] = feeds[i];
        }
    }

    // Comptroller needs prices in the format: ${raw price} * 1e36 / baseUnit
    // The baseUnit of an asset is the amount of the smallest denomination of that asset per whole.
    // For example, the baseUnit of ETH is 1e18.
    // Since the prices in this view have 6 decimals, we must scale them by 1e(36 - 6)/baseUnit
    function getUnderlyingPrice(address cToken) external view returns (uint) {
        address underlyingToken = cTokenInterface(cToken).underlying();
        bytes32 tokenFeed = tokenFeeds[underlyingToken];
        PythStructs.Price memory tokenPrice = pythMain.getPriceUnsafe(tokenFeed);
        uint32 priceExpo = tokenPrice.expo > 0 ? uint32(tokenPrice.expo) : uint32(-tokenPrice.expo);
        uint64 tPrice = tokenPrice.price > 0 ? uint64(tokenPrice.price) : 0;
        return uint(tPrice) * 1e36 / uint(10 ** priceExpo) / 10 ** (uint(EIP20Interface(underlyingToken).decimals()));
    }
}