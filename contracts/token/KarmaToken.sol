pragma solidity ^0.4.19;


import "./StandardToken.sol";


/*
 * SimpleToken
 *
 * Very simple ERC20 Token example, where all tokens are pre-assigned
 * to the creator. Note they can later distribute these tokens
 * as they wish using `transfer` and other `StandardToken` functions.
 */
contract KarmaToken is StandardToken {

  string public name = "KarmaToken";
  string public symbol = "KRM";
  uint public decimals = 18;
  
}