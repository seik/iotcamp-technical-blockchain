pragma solidity ^0.4.19;


import './ERC20.sol';
import '../SafeMath.sol';


/**
 * Standard ERC20 token
 *
 * https://github.com/ethereum/EIPs/issues/20
 * Based on code by FirstBlood:
 * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20 {
  using SafeMath for uint256;

  mapping(address => uint256) balances;
  mapping (address => mapping (address => uint256)) allowed;

  address owner;

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;  
  } 

  function StandardToken() public {
    owner = msg.sender;
  }

  function setOwner(address _owner) onlyOwner public {
    owner = _owner;
  }

  function generate(address _to, uint256 _amount) onlyOwner public returns (bool success) {
    balances[_to] = balances[_to].add(_amount);
    emit Transfer(msg.sender, _to, _amount);
    return true;
  }

  function upvote(address _from, address _to) onlyOwner public returns (bool success) {
    balances[_from] = balances[_from].sub(1);
    balances[_to] = balances[_to].add(1);
    emit Transfer(_from, _to, 1);
    return true;
  }

  function transfer(address _to, uint256 _value) public returns (bool success) {
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
    uint256 _allowance = allowed[_from][msg.sender];
    balances[_to] = balances[_to].add(_value);
    balances[_from] = balances[_from].sub(_value);
    allowed[_from][msg.sender] = _allowance.sub(_value);
    emit Transfer(_from, _to, _value);
    return false;
  }

  function balanceOf(address _owner) view public returns (uint256 balance) {
    return balances[_owner];
  }

  function approve(address _spender, uint256 _value) public returns (bool success) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }

}