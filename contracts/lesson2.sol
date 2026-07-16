// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 < 0.9.0;

import "hardhat/console.sol";
import "lib/my_lib.sol";


contract Sample{

    using MyLib for uint;
    using console for string;

    error NotOwner(address init);
    error NotEnoughMoney(uint expected, uint current);

    event WithdrawEvent(uint value);
    event DonateEvent(address indexed sender, uint value);

    modifier isOwner(){
        console.log("Who's trying get access to owner functions: ", msg.sender);
        require(owner == msg.sender, NotOwner(msg.sender));
        _;
    }

    modifier minValue(uint min_value){
        require(msg.value >= min_value, NotEnoughMoney(min_value, msg.value));
        _;
    }

    address owner;
    constructor(){
        owner = msg.sender;
        string memory log = "Contract succesfully deployed";
        log.log();
    }

    function add_ten(uint value) pure public returns(uint){

        console.log("Get max: your value -> %d, other -> 10. Max -> %d", value, value.get_max(10));

        return value.sum(10);
    }

    function sum(uint a, uint b) pure external returns(uint){
        return MyLib.sum(a,b);
    }
    function get_max(uint a, uint b) pure external returns(uint){
        return MyLib.get_max(a,b);
    }

    function donate() external minValue(1000000000) payable{
        console.log("!!New donate!!");
        emit DonateEvent(msg.sender, msg.value);
    }

    function withdraw() isOwner external{
        // if(msg.sender != owner){
        //     // return;
        //     // revert("You are not owner");
        //     revert NotOwner(msg.sender);
        // }

        // require(msg.sender == owner, "You are not owner");
        // require(msg.sender == owner, NotOwner(msg.sender));

        // assert(owner == msg.sender);

        uint contract_balance = address(this).balance;
        payable(owner).transfer(contract_balance);
        console.log("Owner gets ETH from contract");
        emit WithdrawEvent(contract_balance);
    }
    function only_owner() external view isOwner returns( string memory){
        return "Success";
    }
}