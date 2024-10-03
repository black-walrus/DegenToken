// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {

    struct Item {
        string name; 
        uint price; 
    }

    address public owner; 
    mapping(uint => Item) public gameStore; 

    gameStore[0] = Item("Potion", 1);
    gameStore[1] = Item("Royal Sword", 50);
    gameStore[2] = Item("Dragon Armor", 25); 
     
    constructor() ERC20("Degen", "DGN") {
        owner = msg.sender; 
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _; 
    }

    function redeem(uint itemID) public {
        require(itemID > 0, "Supply a valid Item ID");
        require(balanceOf(msg.sendere) >= gameStore[itemID].price, "Insufficient DGN Tokens");  
        _burn(msg.sender, price); 
    }

    function mint(address to, uint amount) public onlyOwner {
        _mint(to, amount);
    }

    function transfer(address to, uint amount) public override returns (bool) {
        require(amount > 0, "Transfer of more than 0 DGN is required!");
        require(balanceOf(msg.sender) >= amount, "Insufficient DGN to transfer");
        _transfer(msg.sender, to, amount);
    }
    
    function balance() public returns (uint) {
        return balanceOf(msg.sender);
    }

    function burn(uint amount) public {
        require(amount > 0, "Burn amount of more than 0 DGN is required!");
        require(balanceOf(from) >= amount, "Insufficient amount of DGN to burn");
        _burn(msg.sender, amount);
    }

    function getItem(uint itemID) public view returns (Item memory) {
        return gameStore[itemID]; 
    }
}
