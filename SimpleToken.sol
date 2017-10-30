pragma solidity ^0.4.18;

contract ERC20 {
    function totalSupply() constant returns (uint totalSupply);
    function balanceOf(address _owner) constant returns (uint balance);
    function allowance(address _owner, address _spender) constant returns (uint remaining);
    function transfer(address _to, uint _value) returns (bool success);
    function transferFrom(address _from, address _to, uint _value) returns (bool success);
    function approve(address _spender, uint _value) returns (bool success);
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}

contract Math {

    function Mul(uint a, uint b) internal returns (uint) {
      uint c = a * b;
      assert(a == 0 || c / a == b);
      return c;
    }

    function Div(uint a, uint b) internal returns (uint) {
      assert(b > 0);
      uint c = a / b;
      assert(a == b * c + a % b);
      return c;
    }
    
    function Sub(uint a, uint b) internal returns (uint) {
      assert(b <= a);
      uint c = a - b;
      return c;
    }

    function Add(uint a, uint b) internal returns (uint) {
      uint c = a + b;
      assert(c>=a && c>=b);
      return c;
    }

    function assert(bool assertion) internal {
      if (!assertion) {
          throw;
      }
    }
}

contract simpleToken is Math, ERC20 {
    
    
    string tokenName;
    string tokenSymbol;
    uint tokenValue;
    uint _totalSupply = 1000;
    address _owner;
    
    mapping(address => uint) balance;
    
    mapping(address => mapping (address => uint)) allowed;
    
    function plainToken() {
        tokenName = 'simple';
        tokenSymbol = 'SIM';
        tokenValue = 1;
        _owner = msg.sender;
        balance[_owner] = _totalSupply;
    }
    
    function totalSupply() constant returns(uint totalsupply) {
        return _totalSupply;
    }
    
    function balanceOf(address _owner) constant returns (uint) {
        return _totalSupply;
    }
    
    function transfer(address to, uint value) returns(bool success) {
        if((balance[msg.sender] > value) && value > 0) {
            balance[msg.sender] = Sub(balance[to], value);
            balance[to] = Add(balance[to], value);
            return true;
        }
        else {
            return false;
        }
    }
    
    function transferFrom(address _from, address _to, uint _value) returns(bool success) {
        if(balance[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
            balance[_to] += _value;
            balance[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        }
        else {
            return false;
        }
    }
    
    function approve(address _spender, uint _value) returns(bool success) {
        if ((_value != 0) && (allowed[msg.sender][_spender] !=0)) throw;
        
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function allowance(address _owner, address _spender) constant returns(uint remaining) {
        return allowed[_owner][_spender];
    }
}
