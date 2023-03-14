// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract MaputoToken{
    string public  name;
    string public symbol;
    uint8 public decimals;
    uint256 totalSupply;
    mapping(address => uint256) public balanceOf;
    address public owner;
    uint public philanthropicValue;
    uint256 public count;

    mapping(address => mapping(address => uint)) public allowance;

    address public philanthropicAddress;
    uint public philanthropicFee = 1; // 0.01%


    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }


    constructor(){
        //My Maputo Token is called Otupam, then it is a anagram of Maputo >< Otupam
        name = "Otupam"; 
        symbol = "OTM";
        owner = msg.sender;
        decimals= 8;
        totalSupply = 10**9 * 10 **uint(decimals); 
        balanceOf[address(0)] = totalSupply;  
        count = 1;  
        
    }    

        function setPhilanthropicAddress(address _address) public onlyOwner {

        philanthropicAddress = _address;
    }

    function mint() public {
        require(balanceOf[address(0)] >= 10000 * 10**uint(decimals));
        require(count == 1);
        balanceOf[msg.sender] += 10000 * 10**uint(decimals);
        balanceOf[address(0)] -= 10000 * 10**uint(decimals);
         
        count ++;
    }

    function transfer(address _to, uint256 _value) public returns (bool success){

        philanthropicValue = (_value * philanthropicFee) / 10000;

        require(balanceOf[msg.sender] >= _value+philanthropicValue);
        require(_to != address(0));
        require( philanthropicAddress != address(0));

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        balanceOf[philanthropicAddress] += philanthropicValue;

        emit Transfer(msg.sender, _to, _value);

        return true;
    
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        require(allowance[_from][msg.sender] >= _value);
        require(balanceOf[_from] >= _value);
        require(_from != address(0));
        require(_to != address(0));

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);

        return true;

    }


    function approve(address _spender, uint256 _value) public returns (bool success){
        require(balanceOf[msg.sender] >= _value);
        require(_spender != address(0));
        allowance[msg.sender][_spender] = _value;
        
        emit Approval(msg.sender, _spender, _value);

        return true;
    }

}

