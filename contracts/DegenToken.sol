// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {

    struct Item {
        string name; 
        uint price; 
        uint stock; 
    }

    mapping(uint => Item) public gameStore; 
    string[] private itemNames; 


    constructor() ERC20("Degen", "DGN") { 
        gameStore[1] = Item("Potion", 3, 10);
        gameStore[2] = Item("Royal Sword", 50, 10); 
        gameStore[3] = Item("Dragon Armor", 35, 10);

        itemNames.push(gameStore[1].name);
        itemNames.push(gameStore[2].name);
        itemNames.push(gameStore[3].name);
    } 

    function redeem(uint itemID, uint numberItems) public {
        require(itemID > 0, "Supply a valid Item ID");
        require(numberItems > 0, "No. of Items to Purchase must be more than 0");
        require(gameStore[itemID].stock != 0, "Item out of Stock");
        require(gameStore[itemID].stock >= numberItems, "Cannot purchase more than the current stock!");
        require(balanceOf(msg.sender) >= gameStore[itemID].price, "Insufficient DGN Tokens");  
        gameStore[itemID].stock -= numberItems;
        _burn(msg.sender, gameStore[itemID].price * numberItems); 
    }

    function mint(address to, uint amount) public onlyOwner {
        _mint(to, amount);
    }

    function transfer(address to, uint amount) public override returns (bool) {
        require(amount > 0, "Transfer of more than 0 DGN is required!");
        require(balanceOf(msg.sender) >= amount, "Insufficient DGN to transfer");
        _transfer(msg.sender, to, amount);

        return true;
    }
    
    function balance() public view returns (uint) {
        return balanceOf(msg.sender);
    }

    function burn(uint amount) public {
        require(amount > 0, "Burn amount of more than 0 DGN is required!");
        require(balanceOf(msg.sender) >= amount, "Insufficient amount of DGN to burn");
        _burn(msg.sender, amount);
    }

    function addItem(uint itemID, string memory _name, uint _price, uint _stock) public onlyOwner {
        require(itemID > 0, "Item ID Register must be greater than 0");
        require(bytes(_name).length > 0, "Item Name cannot be empty");
        gameStore[itemID] = Item(_name, _price, _stock);
        itemNames.push(_name);
    }

    function getItem(uint itemID) public view returns (Item memory) {
        require(itemID > 0, "Supply valid Item ID");
        return gameStore[itemID]; 
    }

    function getItemName(uint itemID) public view returns (string memory) {
        return gameStore[itemID].name; 
    }

    function getItemPrice(uint itemID) public view returns (uint) {
        return gameStore[itemID].price; 
    }

    function getItemStock(uint itemID) public view returns (uint) {
        return gameStore[itemID].stock;
    }

}
