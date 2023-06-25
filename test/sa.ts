import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat"
import { LP, LP__factory, WomanSeekersNewDawn, WomanSeekersNewDawn__factory } from "../typechain-types";
describe("Sample", function() {
  async function deploy() {
    const [ acc1, acc2 ] = await ethers.getSigners();


    const СollectionFactory = await ethers.getContractFactory("WomanSeekersNewDawn");
    const coll: WomanSeekersNewDawn = await СollectionFactory.deploy();
    await coll.deployed();


    const LPFactory = await ethers.getContractFactory("LP");
    const lp: LP = await LPFactory.deploy(coll.address);
    await lp.deployed();

    return { lp, coll, acc1, acc2 }
  }

  it("allows to call get()", async function() {
    const { lp, coll, acc1, acc2 } = await loadFixture(deploy);

    console.log(lp.address)
    console.log(coll.address)
    
  

});

});