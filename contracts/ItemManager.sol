
/*Project 2 with Solidity and Truffle
SPDX-License-Identifier: MIT*/
pragma solidity ^0.8.11;
import "./Ownable.sol";
import "./Item.sol";


contract itemManager is Ownable
{
    event SupplyChainStepStage(uint _itemIndex, uint _step, address _itemAddress);
    enum itemStepStage{Created, Paid, Delievered}
    
    struct S_Item
    {
        Item _item;
        string _identifier;
        uint _itemPrice;
        itemManager.itemStepStage _stage;
    }
    uint itemIndex;
    mapping(uint =>S_Item) public items;
    
    function createItem(string memory _identifier, uint _itemPrice) public onlyOwner
    {
        Item item = new Item(this, _itemPrice, itemIndex);
        items[itemIndex]._item = item;
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._stage = itemStepStage.Created;
        emit SupplyChainStepStage(itemIndex, uint(items[itemIndex]._stage), address(item));
        itemIndex++;
    }
    
    function triggerPayment(uint _itemIndex) public payable
    {
        require(items[_itemIndex]._itemPrice == msg.value, "Only full payment accepted");
        require(items[_itemIndex]._stage == itemStepStage.Created, "Item is in further stage");
        items[_itemIndex]._stage = itemStepStage.Paid;
        
        emit SupplyChainStepStage(_itemIndex, uint(items[_itemIndex]._stage), address(items[_itemIndex]._item));
    }
    
    function triggerDelievery(uint _itemIndex) public onlyOwner
    {
        require(items[_itemIndex]._stage == itemStepStage.Paid, "Item is in further stage");
        items[_itemIndex]._stage = itemStepStage.Delievered;
        
        emit SupplyChainStepStage(_itemIndex, uint(items[_itemIndex]._stage), address(items[_itemIndex]._item));
    }
    
}