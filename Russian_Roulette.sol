// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.9;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 */
contract Russian_Roulette{
    address[] players;
    address[] losers;
    uint256 odds;
    uint256 playersTurn;
    address creator;
    constructor(){
        creator = msg.sender;
    }
    function setOdds(uint256 oneInThisMany) public {
        require (msg.sender == creator,"Caller isn't creator");
        odds = oneInThisMany;
    }
    function contains(address[] memory array, address term) pure private returns (bool) 
    {
        for(uint256 a=0;a<array.length;a++){
            if(array[a]==term)
            {
               return true;
            }
        }
        return false;
    }
    function addPlayer (address Player) public{
        if(!contains(losers,Player) && !contains(players,Player))
        {
            players.push(Player);
        }
    }
    function random() private view returns (uint256){
        return (uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, creator)))%(odds-1))+1;
    }
    function lose(address Player) private{
        require(contains(players,Player));
        delete players;
        losers.push(Player);
        
    }
    function play() public {
        if (random() == 1){
            lose(players[playersTurn]);
            playersTurn = 0;
        }
        else{
            playersTurn += 1;
            playersTurn % players.length;
        }
    }
    function isALoser(address Player) view public returns (bool){
        return contains(losers, Player);
    }
}