// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWomanSeekersNewDawn.sol";
import "./IERC20.sol";
import "./console.sol";

contract LP is Ownable {
    IWomanSeekersNewDawn Collection;
    IERC20 public LPToken;

    uint256 defEnergyAccrual = 10;
    uint256 energyPriceInTokens = 2; // 2 токенов за одну энергию
    uint256 defaultDamage = 10000;

    
        event duelFinished(address indexed  winner, uint256 _indexRoom, uint256[] damages, bool _wasEnergyFactorIncreased);

        event duelAttackLogs(address indexed  player, uint256 _indexRoom, uint256[] damages);


        event DiscountReceived(address _player);
        event LPTokensGiven(address _player, uint256 _amount);

        
        event BossDefeated(address indexed  player, uint256 indexed  bossLevel, uint256[] damages);
        event BossLost(address indexed  player, uint256 indexed  bossLevel, uint256[] damages);

        

    


    mapping(address => Player) public players;
    mapping(uint256 => bossSpecs) public bosses;

    struct Player {
        uint256 qtyBossDefeated;
        uint256 energyFactor; //мультипликатор повышения энергии, по дефолту равен 1
        uint256 energyBalance; // баланс энергии, на момент начала игры равен 0
        uint256 amountTokensInGame; // количество токенов которыми играет юзер, учитывается только в конце
        uint256 lastTimestampClaimedEnergy;
        uint256[] playingTokenIds; // токен идсы которыми играет юзер
        bool isPlaying;
    }
    //  нужно ли добавить массив tokenId которыми он играет?



    function getInfoPlayer(address _player) public view returns(Player memory) {
        return players[_player];
    }

    struct bossSpecs {
        uint256 health;
        uint256 dodgeChance;
        uint256 attackDamage;
    }

    struct duelInfo {
        uint256 playersNow;
        address[2] players; // 2 игрока
        uint256 totalDamagePlayer0; // тотал дамаг первого игрока
        uint256 totalDamagePlayer1; // тотал дамаг второго игрока
    }

    duelInfo[] public duels;

    constructor(address _collection, address _lptoken) {
        Collection = IWomanSeekersNewDawn(_collection);
        LPToken = IERC20(_lptoken);
        createBoss();
        createBoss();
        createBoss();
        createBoss();
        createNewDuelRoom();
        createNewDuelRoom();
        createNewDuelRoom();

    }

    function createNewDuelRoom() public {

                address[2] memory emptyPlayers;

        duels.push(duelInfo(0, emptyPlayers, 0,0



        ));
    }



    function random(uint256 _value, uint256 _salt) public view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        block.difficulty,
                        blockhash(block.number - 1),
                        msg.sender,
                        _salt
                    )
                )
            ) % _value;
    }
    
    // регулирование начисления энергии в день
    function setDefEnergyAccrual(uint256 _value) public {
        defEnergyAccrual = _value;
    }

        // регулирования прайста токена игры в энергии
    function setEnergyPriceInTokens(uint256 _value) public {
        energyPriceInTokens = _value;
    }

    // дефолтный дамаг у юзера
    function setDefaultDamage(uint256 _value) public {
        defaultDamage = _value;
    }


    function isPlayerInDuelAtIndexRoom( uint256 _indexRoom) public view returns (bool) {
    require(_indexRoom < duels.length, "Invalid duel index");
    
    duelInfo storage currentDuel = duels[_indexRoom];
    if (currentDuel.playersNow > 0) {
        if (currentDuel.players[0] == msg.sender || currentDuel.players[1] == msg.sender) {
            return true;
        }
    }
    
    return false;
}

    function calculateTestDamage() public view returns(uint) {
        return  (defaultDamage * players[msg.sender].energyFactor) * ((random(20,1251250) + 100)/100 );
        
        

    }


        function viewDuelInfo(uint256 _indexRoom) public view returns(duelInfo memory) {
            return duels[_indexRoom];
        }

    function doAttackInDuel(uint256 _indexRoom) public {

        duelInfo storage currentDuel = duels[_indexRoom];

        require(isPlayerInDuelAtIndexRoom(_indexRoom), "you're not in room");               
        
        // проверить что юзер находится в этой игре
        // рассчитать урон за удар
        // отредактировать механику рандома


        uint salt = 132601;
        uint256[] memory damages = new uint256[](3);

        uint totalDamage;


        // калькуляция тотал дамага
        for (uint i = 0; i <= 2; i ++) 
        {
                    uint damage = random(10,salt) * defaultDamage * players[msg.sender].energyFactor;
                damages[i] = damage;
                salt += 126512;
            totalDamage += damage;
        }






        // плюсуем тоталДамаг нужному игроку
        if (currentDuel.players[0] == msg.sender) {

            require(currentDuel.totalDamagePlayer0 == 0, "you're already attacked in duel");

            currentDuel.totalDamagePlayer0 += totalDamage; // добавляем игроку 0
                    emit duelAttackLogs(msg.sender, _indexRoom, damages);

        
        } else {
            require(currentDuel.totalDamagePlayer1 == 0, "you're already attacked in duel");

            currentDuel.totalDamagePlayer1 += totalDamage; // если он не первый то игроку 1
                    emit duelAttackLogs(msg.sender, _indexRoom, damages);


        }



            // если оба тоталДамага существуют то можно сделать калькуляцию победителя
        if(currentDuel.totalDamagePlayer0 != 0 && currentDuel.totalDamagePlayer1 != 0) {

                    //
                    uint salt1 = 2151256;
                  uint chance = random(100, salt1);
            salt += 12723;

        if(chance <=5) {
          // повышаем мультипликатор
            
        }
                        bool wasEnergyFactorIncreased;

            // player0 нанес больший дамаг
            if(currentDuel.totalDamagePlayer0 > currentDuel.totalDamagePlayer1) {
                            // перевод ставки токенов
                            LPToken.transfer(currentDuel.players[0], duelPrice * 2);

                            // возможное увеличение мультипликатора
                             if(chance <=5) {
                                 
                                 players[currentDuel.players[0]].energyFactor += 1;
                                 wasEnergyFactorIncreased = true;
                                
                            }

                            // порождение ивента + включить был ли увеличен мультипликатор игрока

                            emit duelFinished(currentDuel.players[0], _indexRoom, damages, wasEnergyFactorIncreased);

                
            } else {

                // перевод ставки токенов
                            LPToken.transfer(currentDuel.players[1], duelPrice * 2 );

                            // возможное увеличение мультипликатора
                             if(chance <=5) {
                                 players[currentDuel.players[0]].energyFactor += 1;
                                                                  wasEnergyFactorIncreased = true;

                            }
                             emit duelFinished(currentDuel.players[1], _indexRoom, damages, wasEnergyFactorIncreased);


                            // порождение ивента + включить был ли увеличен мультипликатор игрока

            }


            // удаление записи игры

            delete duels[_indexRoom];

        }


       

  
    }


    // function claimDuel() public view returns (uint256) {
    //     // кто должен клеймить? ( тот кто бил последним)

    //             duelInfo storage currentDuel = duels[findAvailableDuel()];


    //     uint256 winnerIndex;
    //     if (currentDuel.totalDamagePlayer0 > currentDuel.totalDamagePlayer1) {
    //         winnerIndex = 0;
    //     } else {
    //         winnerIndex = 1;
    //     }

        
    // //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    //     // функция рандома дает индекс, если индекс равен 5% то
    //     //повышаем мультипликатор энергии winnerIndex

    //     // ставку токенов переводим победителю

    //     return 1;
    // }



    uint256 public duelPrice = 1000;

    function findAvailableDuel() public view returns(uint256) {

        for (uint i = 0; i < duels.length; i++) {
         
        if(duels[i].playersNow !=2) {
            return i;
        }

        }

        revert("could not find available duel room");


    }

        // findAvailableDuel возвращает i комнаты куда можно запушить хотя бы одного игрока
        //ЗАПИСЫВАЕТ ЛЮБОГО ИГРОКА НА НУЛЕВОЙ ИНДЕКС PLAYERS
    function enterInDuel() public {

        duelInfo storage currentDuel = duels[findAvailableDuel()];
        console.log(findAvailableDuel());

        require(currentDuel.players[0] != msg.sender && currentDuel.players[1] != msg.sender, "you're already in this duel");
     


        // если мы получили currentDuel значит дуэль рум уже точно может принять игрока

            if(currentDuel.players[0] == address(0)) {
            currentDuel.players[0] = msg.sender;

            } else {
            currentDuel.players[1] = msg.sender;

            }


            // трансфер цены дуэли от игрока на адрес контракта в lpToken'ах
            LPToken.transferFrom(msg.sender, address(this), duelPrice );

            currentDuel.playersNow++;

    }

    
    uint bosscounter = 1;

    function createBoss() internal {
         // Создаем нового игрока
        bossSpecs storage newBoss = bosses[bosscounter];


        if(bosscounter == 1) {
        newBoss.health = 1000;
        newBoss.dodgeChance = 25;
        newBoss.attackDamage = 300;
        }
      

               if(bosscounter == 2) {
        newBoss.health = 2000;
        newBoss.dodgeChance = 30;
                newBoss.attackDamage = 300;

        }


           if(bosscounter == 3) {
        newBoss.health = 3000;
        newBoss.dodgeChance = 40;
                newBoss.attackDamage = 300;

        }

           if(bosscounter == 4) {
        newBoss.health = 4000;
        newBoss.dodgeChance = 50;
                newBoss.attackDamage = 300;

        }
        
        bosscounter++;
    }

    function checkOwnershipOfTokenIds(uint256[] calldata _tokenIds) public view returns(bool) {
        
    }

    function enterInGame(uint256[] calldata _tokenIds) public {
        // Создаем нового игрока
        Player storage Newplayer = players[msg.sender];


        // должны проверить что юзер обладает этими токен ids

        // Устанавливаем начальные значения
        Newplayer.qtyBossDefeated = 0;
        Newplayer.energyFactor = 1;
        Newplayer.energyBalance = 0;
        Newplayer.amountTokensInGame = 0;
        Newplayer.lastTimestampClaimedEnergy = 0;
        Newplayer.amountTokensInGame = _tokenIds.length;
        Newplayer.isPlaying = true;


        // Добавляем токены, которыми играет игрок
        for (uint256 i = 0; i < _tokenIds.length; i++) {
            Newplayer.playingTokenIds.push(_tokenIds[i]);
            require(!Collection.viewNotTransferable(_tokenIds[i]), "This token already in game");
            Collection.setNotTransferable(_tokenIds[i], true);
        }
    }

    function leaveGame() public {
        //разморозить токен идс и удалить ячейку маппинга

        // сделать проверку на то что юзер находится в игре

        require(players[msg.sender].isPlaying == true, "you're out of game");


        for (
            uint256 i = 0;
            i < players[msg.sender].playingTokenIds.length;
            i++
        ) {
            Collection.setNotTransferable(
                players[msg.sender].playingTokenIds[i],
                false
            );
            // возможно как то еще придется маркировать токен
        }


        delete players[msg.sender];
    }

    //энергия может клеймиться только раз в день, это фиксированное значение помноженное на фактор игрока
    function claimDailyEnergy() public {
        // проверяем что прошел более чем один день с момента прошлого клейма энергии

        // проверяем что игрок играет
        require(players[msg.sender].energyFactor >= 1, "you're out of game");
        require(
            block.timestamp >=
                players[msg.sender].lastTimestampClaimedEnergy + 1 days,
            "try later"        );

        console.log("//////");
            console.log( defEnergyAccrual * players[msg.sender].energyFactor);
                        console.log( defEnergyAccrual );
                                                console.log(      players[msg.sender].energyFactor );

                      console.log("//////"); 


        players[msg.sender].lastTimestampClaimedEnergy = block.timestamp;
        players[msg.sender].energyBalance +=
            defEnergyAccrual * players[msg.sender].energyFactor;
    }

    function buyEnergyForTokens(uint256 _amountEnergy) public {

        //be sure that you have approve

        uint256 amountToPayTokens = _amountEnergy * energyPriceInTokens;
        

        LPToken.approve(address(this), amountToPayTokens);


        LPToken.transferFrom(msg.sender, address(this), amountToPayTokens);

        players[msg.sender].energyBalance += _amountEnergy;

        // добавить еще какие то проверки
    }


    function approveFromGame3(address _who, uint256 _value) public {
                LPToken.approve(_who, _value);

    }



    function fightWithBoss(uint256 _bossLevel) public  {

                require(_bossLevel -1 == players[msg.sender].qtyBossDefeated , "not corresponding boss for you");


            // проверка что юзер обладает достаточным количеством энергии для начала боя с боссом
        require(players[msg.sender].energyBalance >= bosses[_bossLevel].health, "you don't have enough energy for this boss");
            uint totalDamage;
                uint salt = 1255215;
            uint256[] memory damages = new uint256[](3);

        for (uint i = 0; i <= 2; i ++) 
        {
                    uint damage = (((random(10, salt) * defaultDamage * players[msg.sender].energyFactor) * bosses[_bossLevel].dodgeChance)/100);
                damages[i] = damage;
                                    console.log(damage);
                                    salt += 12551;

            totalDamage += damage;
        }

        

            // возвращать бул или читать ивент?
        if(totalDamage >= bosses[_bossLevel].health) {
            // перевести игрока на новый левел
            players[msg.sender].qtyBossDefeated = _bossLevel;
            console.log("win");
            emit BossDefeated(msg.sender, _bossLevel, damages);
            
        } else {
            console.log("lose");
          
                    // занулить его энергию?
                    unchecked{
                players[msg.sender].energyBalance -= bosses[_bossLevel].attackDamage *3;

                    }
            emit BossLost(msg.sender, _bossLevel, damages);
        }

    }

    

    function checkOwnershipOfTokens(uint256[] memory _tokenIds) public view returns(bool) {

        for (uint i = 0; i < _tokenIds.length; i++) 
        { // tx origin or msg.sender ?
           if(Collection.ownerOf(_tokenIds[i]) != tx.origin) {
               return false;
           }
        }
        return true;
    }

    mapping(uint256 => bool) public isTokenIdClaimed;

    function isTokensClaimedTreasures(uint256[] memory _tokenIds) public view returns(bool) {


             for (uint i = 0; i < _tokenIds.length; i++) 
        {
           if(isTokenIdClaimed[_tokenIds[i]] ) {
               return true;
           }
        }
        return false;



    }



    // даем либо токены либо скидку на нфт
    function getFinalTreasures(uint256[] memory _tokenIds, uint _salt) public   {
        // проверить что юзер победил всех боссов
        // функция получениярандомного индекса
        // выплата токенов ли бо нфт
        //

        // маркировать токен как получивший выигрыш 
       require(players[msg.sender].qtyBossDefeated == 4, "you have to defeat all bosses");
       require(checkOwnershipOfTokens( _tokenIds), "you're not owner of these tokenIds");
       require(!isTokensClaimedTreasures( _tokenIds), "tokens were claimed");



        for (uint i = 0; i < _tokenIds.length; i++) {
             isTokenIdClaimed[_tokenIds[i]] = true;
            uint chance = random(10, _salt);
            _salt += 16236;

        if(chance <=2) {

            amountDiscounts[msg.sender]++;
            emit DiscountReceived(msg.sender);
            console.log("got discount");

            

          
            
        } else {
        LPToken.transfer( msg.sender, 10000);

        emit LPTokensGiven(msg.sender,  10000);
        console.log("lpTokensGiven");


        }}

        
    

    }

    mapping(address => uint) public amountDiscounts;

    function viewAmountDiscountForUser(address _player) public view returns(uint) {
        return amountDiscounts[_player];
 
    }

    function MintWithDiscountFromGame(uint256 _mintAmount) public {

        require(_mintAmount >= amountDiscounts[msg.sender], "not enough discounts");

        
            amountDiscounts[msg.sender] -= _mintAmount;
                    Collection.mintFromGame(_mintAmount);

    }

    // таинственный эффект есть после победы над вторым и над третьим боссом
        // бонус есть после победы над первым вторым и третьим боссом

    mapping (address => bool[5]) public RiseClaimMap;


    


    // не забыть убрать ограничение на клейм бонусов
    // 1 = первый бонус, 2 = второй бонус, 3 = третий бонус
    function claimBonus(uint _ordinal) public {

        // на бонусы идут  0 1 2


           require(players[msg.sender].qtyBossDefeated >= _ordinal, "before you need beat necessary boss");
           require(_ordinal <=3, "no more three bonuses now"); 
                // если он хочет заклеймить первый таинственный бонус то мы проверяем

                // если orderPosition = 1, то проверит что юзер еще не клеймил первый таинственный эффект
            require(!RiseClaimMap[msg.sender][_ordinal-1], "you're already claimed this bonus");

        uint chance = random(10, 125125);

         if(chance <=2) {
            players[msg.sender].energyFactor += 10;
            
        } else {
        
        players[msg.sender].energyBalance += 1000;
        
    }

                RiseClaimMap[msg.sender][_ordinal-1] = true;

    }



            // [3] и [4] для боссов, нужно победить 2 и 3 босса
            // если хочешь заклеймить свой первый бонус то должен победить 2х боссов, вводишь 
     function claimMysticEffect(uint _ordinal) public {

            require(players[msg.sender].qtyBossDefeated + 1 >= _ordinal, "before you need beat necessary boss");
            require(_ordinal >= 2 && _ordinal <4, "out of range"); // ЛИБО 2 ЛИБО 3 НА ДАННЫЙ МОМЕНТЫ
                // если он хочет заклеймить первый таинственный бонус то мы проверяем

                // если orderPosition = 1, то проверит что юзер еще не клеймил первый таинственный эффект
            require(!RiseClaimMap[msg.sender][_ordinal+1], "you're already claimed this effect");
        uint chance = random(10, 125125);

         if(chance <=2) {
            players[msg.sender].energyFactor += 10;
            
        } else {
        
        unchecked {
                players[msg.sender].energyFactor -= 10;
        }
    

            RiseClaimMap[msg.sender][_ordinal+1] = true;
    }}









    }
