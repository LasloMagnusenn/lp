// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWomanSeekersNewDawn.sol";
import "./IERC20.sol";

contract LP is Ownable {
    IWomanSeekersNewDawn Collection;
    IERC20 LPToken;

    uint256 defEnergyAccrual = 10;
    uint256 energyPriceInTokens = 100; // 100 токенов за одну энергию
    uint256 defaultDamage = 100;

    


    mapping(address => Player) public players;
    mapping(uint256 => bossSpecs) public bosses;

    struct Player {
        uint256 qtyBossDefeated;
        uint256 energyFactor; //мультипликатор повышения энергии, по дефолту равен 1
        uint256 energyBalance; // баланс энергии, на момент начала игры равен 0
        uint256 amountTokensInGame; // количество токенов которыми играет юзер, учитывается только в конце
        uint256 lastTimestampClaimedEnergy;
        uint256[] playingTokenIds; // токен идсы которыми играет юзер
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

    constructor(address _collection) {
        Collection = IWomanSeekersNewDawn(_collection);
        createBoss();
        createBoss();
        createBoss();
        createBoss();

    }

    function createNewDuelRoom() public {

                address[2] memory emptyPlayers;

        duels.push(duelInfo(
                0, emptyPlayers, 0,0



        ));
    }



    function random(uint256 _value) public view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        block.difficulty,
                        blockhash(block.number - 1),
                        msg.sender
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
        return  (defaultDamage * players[msg.sender].energyFactor) * ((random(20) + 100)/100 );
        
        

    }


        event duelAttackLogs(address indexed  player, uint256 _indexRoom, uint256[] damages);

    function doAttackInDuel(uint256 _indexRoom) public {

                duelInfo storage currentDuel = duels[_indexRoom];

        require(isPlayerInDuelAtIndexRoom(_indexRoom), "you're not in room");               

        // проверить что юзер находится в этой игре
        // рассчитать урон за удар
        // отредактировать механику рандома



        uint256[] memory damages = new uint256[](3);

        uint totalDamage;

        for (uint i = 0; i <= 2; i ++) 
        {
                    uint damage = random(10) * defaultDamage * players[msg.sender].energyFactor;
                damages[i] = damage;
            totalDamage += damage;
        }







        if (currentDuel.players[0] == msg.sender) {
            
            currentDuel.totalDamagePlayer0 += totalDamage; // добавляем игроку 0
        
        
        } else {
            currentDuel.totalDamagePlayer1 += totalDamage; // если он не первый то игроку 1
        }


        emit duelAttackLogs(msg.sender, _indexRoom, damages);
       

  
    }


    uint256 public duelPrice = 1000;

    function findAvailableDuel() public view returns(uint256) {

        for (uint i = 0; i < duels.length; i++) {
         
        if(duels[i].playersNow !=2) {
            return i;
        }

        }

        revert("could not find available duel room");


    }

    function enterInDuel() public {

        duelInfo storage currentDuel = duels[findAvailableDuel()];
        

        // если мы получили currentDuel значит дуэль рум уже точно может принять игрока


            currentDuel.players[0] = msg.sender;
            LPToken.transferFrom(msg.sender, address(this), duelPrice );

            currentDuel.playersNow++;
        

        // перевод ставки токенов в контракт чекнуть

    }

    function claimDuel() public view returns (uint256) {
        // кто должен клеймить? ( тот кто бил последним)

                duelInfo storage currentDuel = duels[findAvailableDuel()];


        uint256 winnerIndex;
        if (currentDuel.totalDamagePlayer0 > currentDuel.totalDamagePlayer1) {
            winnerIndex = 0;
        } else {
            winnerIndex = 1;
        }

        
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        // функция рандома дает индекс, если индекс равен 5% то
        //повышаем мультипликатор энергии winnerIndex

        // ставку токенов переводим победителю

        return 1;
    }

    uint bosscounter = 1;

    function createBoss() internal {
         // Создаем нового игрока
        bossSpecs storage newBoss = bosses[bosscounter];


        if(bosscounter == 1) {
        newBoss.health = 1000;
        newBoss.dodgeChance = 25;
        }
      

               if(bosscounter == 2) {
        newBoss.health = 2000;
        newBoss.dodgeChance = 30;
        }


           if(bosscounter == 3) {
        newBoss.health = 3000;
        newBoss.dodgeChance = 40;
        }

           if(bosscounter == 4) {
        newBoss.health = 4000;
        newBoss.dodgeChance = 50;
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

        // Добавляем токены, которыми играет игрок
        for (uint256 i = 0; i < _tokenIds.length; i++) {
            Newplayer.playingTokenIds.push(_tokenIds[i]);
            require(!Collection.viewNotTransferable(_tokenIds[i]), "This token already in game");
            Collection.setNotTransferable(_tokenIds[i], true);
        }
    }

    function leaveGame() public {
        //разморозить токен идс и удалить ячейку маппинга

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

        require(
            block.timestamp >=
                players[msg.sender].lastTimestampClaimedEnergy + 1 days,
            "try later"
        );

        players[msg.sender].lastTimestampClaimedEnergy = block.timestamp;
        players[msg.sender].energyBalance +=
            defEnergyAccrual *
            players[msg.sender].energyFactor;
    }

    function buyEnergyForTokens(uint256 _amountEnergy) public {
        uint256 amountToPayTokens = _amountEnergy * energyPriceInTokens;

        LPToken.transferFrom(msg.sender, address(this), amountToPayTokens);

        players[msg.sender].energyBalance += _amountEnergy;

        // добавить еще какие то проверки
    }

        event BossDefeated(address indexed  player, uint256 indexed  bossLevel, uint256[] damages);

    function fightWithBoss(uint256 _bossLevel) public  {

                require(players[msg.sender].qtyBossDefeated < _bossLevel, "you're already beaten this boss");


            // проверка что юзер обладает достаточным количеством энергии для начала боя с боссом
        require(players[msg.sender].energyBalance >= bosses[_bossLevel].health, "you don't have enough energy for this boss");
            uint totalDamage;

            uint256[] memory damages = new uint256[](3);

        for (uint i = 0; i <= 2; i ++) 
        {
                    uint damage = random(10) * defaultDamage * players[msg.sender].energyFactor;
                damages[i] = damage;
            totalDamage += damage;
        }

        bosses[_bossLevel].health -= totalDamage;


            // возвращать бул или читать ивент?
        if(bosses[_bossLevel].health == 0) {
            // перевести игрока на новый левел
            players[msg.sender].qtyBossDefeated = _bossLevel;
            emit BossDefeated(msg.sender, _bossLevel, damages);
            
        } else {
          
                    // занулить его энергию?
                    players[msg.sender].energyBalance -= bosses[_bossLevel].attackDamage *3;
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
    function getFinalTreasures(uint256[] memory _tokenIds) public payable  {
        // проверить что юзер победил всех боссов
        // функция получениярандомного индекса
        // выплата токенов ли бо нфт
        //

        // маркировать токен как получивший выигрыш 
        require(players[msg.sender].qtyBossDefeated == 3, "you have to defeat all bosses");
       require(checkOwnershipOfTokens( _tokenIds), "you're not owner of these tokenIds");
       require(!isTokensClaimedTreasures( _tokenIds), "tokens were claimed");


        uint totalMsgValue;

        for (uint i = 0; i < _tokenIds.length; i++) {
             isTokenIdClaimed[_tokenIds[i]] = true;
            uint chance = random(10);

        if(chance <=2) {
            totalMsgValue += (Collection.viewNFTCost() * 20) /100;
    
            Collection.mintFromGame(1);
            
        } else {
        LPToken.transferFrom(address(this), msg.sender, 10000);


        }}

         require(msg.value >= totalMsgValue, "insufficient funds");
        
    

    }

    function testMintDirectFromGame() public {
                    Collection.mintFromGame(1);

    }

    // таинственный эффект есть после победы над вторым и над третьим боссом
        // бонус есть после победы над первым вторым и третьим боссом

    mapping (address => bool[5]) public RiseClaimMap;


    // здесь arr[5] ==>   [0] and [1] - мистические эффекты по порядку // [2] [3] [4] - бонусы на карте по порядку

    function claimMysticEffect(uint _orderPosition) public {

            require(players[msg.sender].qtyBossDefeated >= _orderPosition, "before you need beat necessary boss");
            
                // если он хочет заклеймить первый таинственный бонус то мы проверяем

                // если orderPosition = 1, то проверит что юзер еще не клеймил первый таинственный эффект
            require(!RiseClaimMap[msg.sender][_orderPosition-1], "you're already claimed this effect");
        uint chance = random(10);

         if(chance <=2) {
            players[msg.sender].energyFactor += 10;
            
        } else {
        
        players[msg.sender].energyFactor -= 10;

            RiseClaimMap[msg.sender][_orderPosition-1] = true;
    }}



    
    function claimBonus(uint _orderPosition) public {

        // на бонусы идут индексы 2 3 4


           require(players[msg.sender].qtyBossDefeated >= _orderPosition, "before you need beat necessary boss");
            
                // если он хочет заклеймить первый таинственный бонус то мы проверяем

                // если orderPosition = 1, то проверит что юзер еще не клеймил первый таинственный эффект
            require(!RiseClaimMap[msg.sender][_orderPosition-1], "you're already claimed this bonus");

        uint chance = random(10);

         if(chance <=2) {
            players[msg.sender].energyFactor += 10;
            
        } else {
        
        players[msg.sender].energyBalance += 1000;
        
    }

                RiseClaimMap[msg.sender][_orderPosition-1] = true;

    }
    }
