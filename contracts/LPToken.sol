// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract LPToken is ERC20 {


    constructor() ERC20("LPToken", "RRR") {}

    function mint(address to, uint256 amount) public  {
        _mint(to, amount);
    }

     function decimals() public view virtual override returns (uint8) {
        return 0;
    }
    

    
}