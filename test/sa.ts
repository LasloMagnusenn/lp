import { loadFixture, time } from "@nomicfoundation/hardhat-network-helpers";
import { assert, expect } from "chai";
import { ethers } from "hardhat"
import { LP, LP__factory, WomanSeekersNewDawn, WomanSeekersNewDawn__factory, LPToken, LPToken__factory } from "../typechain-types";
describe("deploy contracts", function() {
  async function deploy() {
    const [ acc1, acc2, acc3 ] = await ethers.getSigners();

    
    const LPTokenFactory = await ethers.getContractFactory("LPToken");
    const lptoken: LPToken = await LPTokenFactory.deploy();
    await lptoken.deployed();



    const СollectionFactory = await ethers.getContractFactory("WomanSeekersNewDawn");
    const coll: WomanSeekersNewDawn = await СollectionFactory.deploy();
    await coll.deployed();


    const LPFactory = await ethers.getContractFactory("LP");
    const lp: LP = await LPFactory.deploy(coll.address, lptoken.address);
    await lp.deployed();



    return { lp, coll, lptoken, acc1, acc2, acc3 }
  }

  // ПОЗЖЕ НАВЕСИТЬ НА ВСЕ ФУНКЦИИ ISPLAYERINGAME


//   it("buy energy for tokens", async function() {



//     const { lp, coll, lptoken,  acc1, acc2 } = await loadFixture(deploy);

    
//     await coll.mint(10, {value: 10});

//     await lp.enterInGame([1,2,3,4]);










//   console.log("энергия до клейма энергии")
//   console.log( (await lp.players(acc1.address)).energyBalance);


//       // нужно будет 101000 токенов
//       await lptoken.mint(acc1.address, 102000);
//       expect(await lptoken.balanceOf(acc1.address)).to.equal(102000)

//       await lptoken.approve(lp.address, 2020);
//     await lp.buyEnergyForTokens(1010);

    
//   console.log("энергия после клейма энергии")
//   console.log( (await lp.players(acc1.address)).energyBalance);




    


  

// });

// it('enter in game, leave game, enter in game', async () => {

//   const { lp, coll, lptoken,  acc1, acc2 } = await loadFixture(deploy);

//   await coll.mint(10, {value: 10});

//   await lp.enterInGame([1,2,3,4]);

//   await lp.leaveGame();

//   await lp.enterInGame([1,2,3,4]);



 
// });

// it("test duels", async function() {



//   const { lp, coll, lptoken,  acc1, acc2, acc3 } = await loadFixture(deploy);

//   await lp.createNewDuelRoom();
//   await lp.createNewDuelRoom();
//   await lp.createNewDuelRoom();

  

  
//   await coll.mint(10, {value: 10});
//   await lp.enterInGame([1,2,3,4]);


//   await coll.connect(acc2).mint(10, {value: 10});
//   await lp.connect(acc2).enterInGame([11,12,13,14]);




//       await lptoken.mint(acc1.address, 102000);
//       await lptoken.approve(lp.address, 102000);


//       await lptoken.mint(acc2.address, 102000);
//       await lptoken.connect(acc2).approve(lp.address, 102000);


//   await lp.enterInDuel();

//   await lp.connect(acc2).enterInDuel();

//   console.log(await lptoken.balanceOf(lp.address));




//   console.log(await lptoken.balanceOf(acc1.address))
//   console.log(await lptoken.balanceOf(acc2.address))




//   await lp.doAttackInDuel(0);
//   await lp.connect(acc2).doAttackInDuel(0);


//   console.log(await lp.viewDuelInfo(0));

//   console.log(await lptoken.balanceOf(acc1.address))
//   console.log(await lptoken.balanceOf(acc2.address))















// });




it("claim bonuses", async function() {


  const { lp, coll, lptoken,  acc1, acc2 } = await loadFixture(deploy);
  
  await coll.mint(10, {value: 10});

  await lp.enterInGame([1,2,3,4,5,6,7,8,9,10] );




console.log("энергия до клейма энергии");

console.log((await lp.players(acc1.address)).energyBalance);


    // нужно будет 101000 токенов
    await lptoken.mint(acc1.address, 10200000);
    expect(await lptoken.balanceOf(acc1.address)).to.equal(10200000)

    await lptoken.approve(lp.address, 10000000);
  await lp.buyEnergyForTokens(5000000);

  
console.log("энергия после клейма энергии")
console.log( (await lp.players(acc1.address)).energyBalance);


await lp.fightWithBoss(1)

await lp.fightWithBoss(2)

await lp.fightWithBoss(3)

await lp.fightWithBoss(4)

console.log((await lp.players(acc1.address)).qtyBossDefeated)

await lp.getFinalTreasures([1,2,3,4,5,6,7,8,9,10], 1230598);

// await lp.claimMysticEffect(2)
// await lp.claimMysticEffect(3)
// await lp.claimBonus(1)
// await lp.claimBonus(2)
// await lp.claimBonus(3)



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