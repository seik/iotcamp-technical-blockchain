pragma solidity ^0.4.19;


/*
 * ERC20 interface
 * see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 {
  function balanceOf(address who) view public returns (uint balance);
  function allowance(address owner, address spender) view public returns (uint remaining);

  function transfer(address to, uint value) public returns (bool success);
  function transferFrom(address from, address to, uint value) public returns (bool success);
  function approve(address spender, uint value) public returns (bool success);

  event Transfer(address indexed from, address indexed to, uint value);
  event Approval(address indexed owner, address indexed spender, uint value);
}