// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

interface IPriceCollector {
    function setDirectPrice(address[] memory asset, uint[] memory price) external;
}
