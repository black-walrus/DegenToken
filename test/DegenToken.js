const { expect } = require("chai");

describe("DegenToken Contract", function() {

    let degenToken, owner, addr1, addr2; 

    beforeEach(async function() {
        degenToken = await ethers.deployContract("DegenToken"); 
        [owner, addr1, addr2] = await ethers.getSigners();
    });

    describe("Deployment", function() {
        it ("Should set to the owner", async function() {
            expect(await degenToken.owner()).to.equal(owner.address);
        }); 

        it ("Should initialize the items in the game store", async function() {

            expect(await degenToken.getItemPrice(1)).to.equal(3);
            expect(await degenToken.getItemStock(1)).to.equal(10);


            expect(await degenToken.getItemPrice(2)).to.equal(50);
            expect(await degenToken.getItemStock(2)).to.equal(10);


            expect(await degenToken.getItemPrice(3)).to.equal(35);
            expect(await degenToken.getItemStock(3)).to.equal(10);
        });
    });

    describe("Minting DegenTokens", function() {
        
        it ("Should mint DegenTokens to owner", async function() {
            await degenToken.mint(owner.address, 100);
            expect(await degenToken.balanceOf(owner.address)).to.equal(100);    
        });

        it ("Should mint DegenTokens to another address", async function() {
            await degenToken.mint(addr1.address, 100);
            expect(await degenToken.balanceOf(addr1.address)).to.equal(100);
        });

        it ("Should fail to mint DegenTokens if not transacted by owner", async function() {
            await expect(degenToken.connect(addr1).mint(addr1.address, 100)).to.be.revertedWith("Ownable: caller is not the owner");    
        });
    });

    describe("Transferring DegenTokens", function() {
        it ("Should transfer DegenTokens between addresses", async function() {
            await degenToken.mint(owner.address, 100);
            await degenToken.transfer(addr1.address, 50); 
            expect(await degenToken.balanceOf(owner.address)).to.equal(50);
            expect(await degenToken.balanceOf(addr1.address)).to.equal(50); 
        });

        it ("Should fail to transfer DegenTokens if amount is zero", async function() {
            await degenToken.mint(addr1.address, 100);
            await expect(degenToken.connect(addr1).transfer(addr2.address, 0)).to.be.revertedWith("Transfer of more than 0 DGN is required!");
        });

        it ("Should fail to transfer DegenTokens if sender does not have enough balance", async function() {
            await degenToken.mint(addr1.address, 50); 
            await expect(degenToken.connect(addr1).transfer(addr2.address, 100)).to.be.revertedWith("Insufficient DGN to transfer"); 
        })
    });

    describe("Burning DegenTokens", function() {
        it ("Should burn DegenTokens from owner", async function() {
            await degenToken.mint(addr1.address, 100);
            await degenToken.connect(addr1).burn(50); 
            expect(await degenToken.balanceOf(addr1.address)).to.equal(50);
        });

        it ("Should fail to burn DegenTokens if amount is zero", async function() {
            await degenToken.mint(addr1.address, 100);
            await expect(degenToken.connect(addr1).burn(0)).to.be.revertedWith("Burn amount of more than 0 DGN is required!");
        });

        it ("Should fail to burn DegenTokens if sender does not have enough balance", async function() {
            await degenToken.mint(addr1.address, 50);
            await expect(degenToken.connect(addr1).burn(100)).to.be.revertedWith("Insufficient amount of DGN to burn");
        }); 
    });

    describe("Redeeming Items", function() {
        it ("Should redeem an item for DegenTokens", async function() {
            await degenToken.mint(addr1.address, 1000);
            await degenToken.connect(addr1).redeem(1, 1);
            expect(await degenToken.getItemStock(1)).to.equal(9);
            expect(await degenToken.balanceOf(addr1.address)).to.equal(997);
        });

        it ("Should redeem multiple items for DegenTokens", async function() {
            await degenToken.mint(addr1.address, 1000);
            await degenToken.connect(addr1).redeem(2, 5);
            expect(await degenToken.getItemStock(2)).to.equal(5);
            expect(await degenToken.balanceOf(addr1.address)).to.equal(750);
        });

        it ("Should fail to redeem an item if item does not exist", async function() {
            await degenToken.mint(addr1.address, 100);
        }); 

        it ("Should fail to redeem an item if supplied Item ID is zero", async function() {
            await degenToken.mint(addr1.address, 1000);
            await expect(degenToken.connect(addr1).redeem(0, 1)).to.be.revertedWith("Supply a valid Item ID");
        });

        it ("Should fail to redeem an item if number of purchased items is zero", async function() {
            await degenToken.mint(addr1.address, 1000);
            await expect(degenToken.connect(addr1).redeem(1, 0)).to.be.revertedWith("No. of Items to Purchase must be more than 0");
        });

        it ("Should fail to redeem an item if sender does not have enough DegenTokens", async function() {
            await degenToken.mint(addr1.address, 1);
            await expect(degenToken.connect(addr1).redeem(1, 1)).to.be.revertedWith("Insufficient DGN Tokens");
        });

        it ("Should fail to redeem an item if item is out of stock", async function() {
            await degenToken.mint(addr1.address, 1000);
            await degenToken.connect(addr1).redeem(1, 10);
            await expect(degenToken.connect(addr1).redeem(1, 1)).to.be.revertedWith("Item out of Stock");
        });

        it ("Should fail to redeem an item if number of items to purchase exceeds the current stock", async function() {
            await degenToken.mint(addr1.address, 1000);
            await expect(degenToken.connect(addr1).redeem(1, 11)).to.be.revertedWith("Cannot purchase more than the current stock!");
        });
    });

    describe("Adding Items", function() {
        it ("Should add an item to the store", async function() {
            await degenToken.addItem(4, "Fire Tome", 35, 10);

            expect(await degenToken.getItemPrice(4)).to.equal(35);
            expect(await degenToken.getItemStock(4)).to.equal(10);
        });

        it ("Should fail to add an item if the owner is not the caller", async function() {
            await expect(degenToken.connect(addr1).addItem(4, "Fire Tome", 35, 10)).to.be.revertedWith("Ownable: caller is not the owner");
        });

        it ("Should fail to add an item if the item ID is zero", async function() {
            await expect(degenToken.addItem(0, "Fire Tome", 35, 10)).to.be.revertedWith("Item ID Register must be greater than 0");
        });

        it ("Should fail to add an item if the item name is empty", async function() {
            await expect(degenToken.addItem(4, "", 35, 10)).to.be.revertedWith("Item Name cannot be empty");
        });

    });
});