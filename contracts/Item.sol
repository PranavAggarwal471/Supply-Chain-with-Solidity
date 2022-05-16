/*Project 2 with Solidity and Truffle
SPDX-License-Identifier: MIT*/
pragma solidity ^0.8.11;
import "./ItemManager.sol";

contract Item
{
    uint public index;
    uint public pricePaid;
    uint public priceInWei;
    itemManager parentContract;
    
    constructor(itemManager _parentContract, uint _priceInWei, uint _index) public
    {
        priceInWei = _priceInWei;
        index = _index;
        parentContract = _parentContract;
    }
    
    receive() external payable
    {
        require(pricePaid == 0, "Item is paid already");
        require(priceInWei == msg.value, "Only full paments allowed");
        pricePaid += msg.value;
        (bool success, ) = address(parentContract).call{value:msg.value}(abi.encodeWithSignature("triggerPayment(uint)",index));
        require(success , "The transaction wasn't successfull, canceling");
        
    }
    fallback() external{}
    
}