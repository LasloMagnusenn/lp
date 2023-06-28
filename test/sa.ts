import { loadFixture, time } from "@nomicfoundation/hardhat-network-helpers";
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

  it("claim daily energy", async function() {



    const { lp, coll, acc1, acc2 } = await loadFixture(deploy);



      await coll.mint(10, {value: 10});

      await lp.enterInGame([1,2,3,4]);




    console.log("энергия до клейма энергии")
    console.log( (await lp.players(acc1.address)).energyBalance);


    console.log("timestamp до клейма энергии")
    console.log( (await lp.players(acc1.address)).lastTimestampClaimedEnergy);


    // клеймим энергию

    const tx = await lp.claimDailyEnergy();
    await tx.wait();



    
    console.log("энергия после первого клейма")
    console.log( (await lp.players(acc1.address)).energyBalance);


    console.log("timestamp  после первого клейма")
    console.log( (await lp.players(acc1.address)).lastTimestampClaimedEnergy);


    await time.increase(90000);


    const tx1 = await lp.claimDailyEnergy();
    await tx1.wait();






    
    
    console.log("энергия после второго клейма")
    console.log( (await lp.players(acc1.address)).energyBalance);


    console.log("timestamp после второго клейма")
    console.log( (await lp.players(acc1.address)).lastTimestampClaimedEnergy);




    
  

});

});