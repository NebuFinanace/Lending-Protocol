// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

interface IWETH {
  function balanceOf(address user) external returns (uint);

  function approve(address to, uint value) external returns (bool);

  function transfer(address to, uint value) external returns (bool);

  function transferFrom(address src, address dst, uint256 amount) external returns (bool success);

  function deposit() external payable;

  function withdraw(uint) external;
}