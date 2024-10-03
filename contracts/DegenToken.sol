// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable(msg.sender) {

    struct Item {
        string name; 
        uint price; 
        uint stock; 
    }

    mapping(uint => Item) public gameStore; 

    constructor() ERC20("Degen", "DGN") { 
        gameStore[1] = Item("Potion", 3, 10);
        gameStore[2] = Item("Royal Sword", 50, 10); 
        gameStore[3] = Item("Dragon Armor", 35, 10);
    }  

    function redeem(uint itemID, uint numberItems) public {
        require(itemID > 0, "Supply a valid Item ID");
        require(numberItems > 0, "No. of Items to Purchase must be more than 0");
        require(gameStore[itemID].stock != 0, "Item out of Stock");
        require(gameStore[itemID].stock >= numberItems, "Cannot purchase more than the current stock!");
        require(balanceOf(msg.sender) >= gameStore[itemID].price, "Insufficient DGN Tokens");  
        _burn(msg.sender, gameStore[itemID].price); 
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

        gameStore[itemID] = Item(_name, _price, _stock);
    }

    function getItem(uint itemID) public view returns (Item memory) {
        require(itemID > 0, "Supply valid Item ID");
        return gameStore[itemID]; 
    }
}
