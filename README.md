# Project Title

This project creates a DegenToken contract, implementing the ERC20 Token Standard by using the 
OpenZeppelin Library, for Degen Gaming to give rewards to their players. 
The DegenToken is created and is transacted on the Avalance Fuji Testnet.  

## Description

The DegenToken contract contains the following features: 

`mint(address to, uint amount)` mints an `amount` of DegenTokens to 
an address `to`. Only the Owner can mint new DegenTokens. 

`transfer(address to, uint amount)` transfers the specified `amount` of 
DGN from one's account (the one making the token transfer) to another address account `to`. 

`balance()` returns the own DGN balance of the caller.

`burn(uint amount)` burns an amount of DGN from the caller's own balance. 

`addItem(uint itemID, string memory, uint price, uint stock)` adds a new item with the registered `itemID`, `price` in DGN, and initial number of the item in stock to the in-game store. Only the owner can transact this function. 

`getItem(uint itemID)` returns the `Item` object with the corresponding 
`itemID`. 

`getItemName(uint itemID)` returns the `name` of the Item with the 
corresponding `itemID`.

`getItemPrice(uint itemID)` returns the `price` of the Item with the 
corresponding `itemID`. 

`getItemStock(uint itemID)` returns the `stock` availability of the Item 
with the corresponding `itemID`. 

## Getting Started

### Prerequisite
- MetaMask Wallet Extension with connection to the Avalanche Fuji Testnet Network and test AVAX in the wallet to pay. Need at least 2 accounts in that network to fully utilize the DegenToken contract. To get Test AVAX, 
go to this Avalance Testnet Faucet - https://core.app/en/tools/testnet-faucet/

### Executing program

1. Go to https://remix.ethereum.org/
2. From the File Explorer, click on leftmost icon under the default workspace to create a new file. 
3. Name the file as "DegenToken.sol". 
4. Copy the following code and paste it onto the new file in REMIX.

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable(msg.sender) {

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

```

5. In the left tab, click Solidity Compiler and set the Compiler version 
matching the pane specified in the contract (ver. 0.8.20). then click
"Compile DegenToken.sol". 
6. In the left tab, click 
Deploy & run transactions and set the environment to 'Injected Provider - Metamask' and fill the field beside the 'At Address' button with the contract address "0x248542cc653aD0C7D11B4579C715A31176664aAe" then click the said button. Make sure that your Fuji Account has enough Test AVAX to deploy the contract.  
7. Scroll down to the Deployed / Unpinned Contracts to interact with the contract. Change account from the ACCOUNT field at the upper part of the pane as needed. 


# Authors

Seth Gruspe

[@black-walrus](https://github.com/black-walrus/)



# License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
