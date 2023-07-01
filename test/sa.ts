import { loadFixture, time } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat"
import { LP, LP__factory, WomanSeekersNewDawn, WomanSeekersNewDawn__factory, LPToken, LPToken__factory } from "../typechain-types";
describe("deploy contracts", function() {
  async function deploy() {
    const [ acc1, acc2 ] = await ethers.getSigners();

    
    const LPTokenFactory = await ethers.getContractFactory("LPToken");
    const lptoken: LPToken = await LPTokenFactory.deploy();
    await lptoken.deployed();



    const СollectionFactory = await ethers.getContractFactory("WomanSeekersNewDawn");
    const coll: WomanSeekersNewDawn = await СollectionFactory.deploy();
    await coll.deployed();


    const LPFactory = await ethers.getContractFactory("LP");
    const lp: LP = await LPFactory.deploy(coll.address, lptoken.address);
    await lp.deployed();



    return { lp, coll, lptoken, acc1, acc2 }
  }

  // ПОЗЖЕ НАВЕСИТЬ НА ВСЕ ФУНКЦИИ ISPLAYERINGAME


  it("buy energy for tokens", async function() {



    const { lp, coll, lptoken,  acc1, acc2 } = await loadFixture(deploy);

    
    await coll.mint(10, {value: 10});

    await lp.enterInGame([1,2,3,4]);




  console.log("энергия до клейма энергии")
  console.log( (await lp.players(acc1.address)).energyBalance);


      // нужно будет 101000 токенов
      await lptoken.mint(acc1.address, 102000);
      expect(await lptoken.balanceOf(acc1.address)).to.equal(102000)

      await lptoken.approve(lp.address, 2020);
    await lp.buyEnergyForTokens(1010);

    
  console.log("энергия после клейма энергии")
  console.log( (await lp.players(acc1.address)).energyBalance);




    


  

});


it("claim bonuses", async function() {



  const { lp, coll, lptoken,  acc1, acc2 } = await loadFixture(deploy);

  
  await coll.mint(10, {value: 10});

  await lp.enterInGame([1,2,3,4]);




console.log("энергия до клейма энергии")
console.log( (await lp.players(acc1.address)).energyBalance);


    // нужно будет 101000 токенов
    await lptoken.mint(acc1.address, 102000);
    expect(await lptoken.balanceOf(acc1.address)).to.equal(102000)

    await lptoken.approve(lp.address, 100000);
  await lp.buyEnergyForTokens(50000);

  
console.log("энергия после клейма энергии")
console.log( (await lp.players(acc1.address)).energyBalance);


await lp.fightWithBoss(1)



await lp.fightWithBoss(3)

await lp.fightWithBoss(4)



console.log((await lp.players(acc1.address)).qtyBossDefeated)

await lp.claimMysticEffect(2)
await lp.claimMysticEffect(3)
await lp.claimBonus(1)
await lp.claimBonus(2)
await lp.claimBonus(3)








  




});



// it("fight with bosses", async function() {



//   const { lp, coll, lptoken,  acc1, acc2 } = await loadFixture(deploy);

  
//   await coll.mint(10, {value: 10});

//   await lp.enterInGame([1,2,3,4]);




// console.log("энергия до клейма энергии")
// console.log( (await lp.players(acc1.address)).energyBalance);


//     // нужно будет 101000 токенов
//     await lptoken.mint(acc1.address, 102000);
//     expect(await lptoken.balanceOf(acc1.address)).to.equal(102000)

//     await lptoken.approve(lp.address, 100000);
//   await lp.buyEnergyForTokens(50000);

  
// console.log("энергия после клейма энергии")
// console.log( (await lp.players(acc1.address)).energyBalance);


// await lp.fightWithBoss(1)



// await lp.fightWithBoss(3)

// await lp.fightWithBoss(4)


  




// });




//   it("claim daily energy", async function() {



//     const { lp, coll, acc1, acc2 } = await loadFixture(deploy);


//       await coll.mint(10, {value: 10});

//       await lp.enterInGame([1,2,3,4]);




//     console.log("энергия до клейма энергии")
//     console.log( (await lp.players(acc1.address)).energyBalance);


//     console.log("timestamp до клейма энергии")
//     console.log( (await lp.players(acc1.address)).lastTimestampClaimedEnergy);


//     // клеймим энергию

//     const tx = await lp.claimDailyEnergy();
//     await tx.wait();



    
//     console.log("энергия после первого клейма")
//     console.log( (await lp.players(acc1.address)).energyBalance);


//     console.log("timestamp  после первого клейма")
//     console.log( (await lp.players(acc1.address)).lastTimestampClaimedEnergy);


//     await time.increase(90000);


//     const tx1 = await lp.claimDailyEnergy();
//     await tx1.wait();






    
    
//     console.log("энергия после второго клейма")
//     console.log( (await lp.players(acc1.address)).energyBalance);


//     console.log("timestamp после второго клейма")
//     console.log( (await lp.players(acc1.address)).lastTimestampClaimedEnergy);




    
  

// });

});