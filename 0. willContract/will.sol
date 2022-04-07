// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Will
 * @dev A smart contract that share eth to people based on the owners will after he/she is deceased 
 */
contract Will {

    address owner;
    uint forture;
    bool isDeceased;


    constructor() payable {
        owner = msg.sender;
        forture = msg.value;
        isDeceased = false;
    }

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    modifier mustBeDeceased(){
        require(isDeceased == true);
        _;
    }

    address payable[] familyAddresses;

    mapping(address => uint) inheritance;

    function setInheritors(address payable wallet, uint amount) public onlyOwner {
        familyAddresses.push(wallet);
        inheritance[wallet] = amount;
    }

    function payout() private mustBeDeceased {
        for(uint i = 0; i < familyAddresses.length; i++){            
            uint amount = inheritance[familyAddresses[i]];

            familyAddresses[i].transfer(amount);
            forture = forture - amount;
        }
    }

    function setDeceased() public {
        isDeceased = true;
        payout();
    }

    function getRemainingForture() public view returns (uint) {
        return forture;
    }


}