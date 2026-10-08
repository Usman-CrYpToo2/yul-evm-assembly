// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;

contract hexToUnit{
  
    function hexToUnitAssigned() pure external returns(uint){
        uint value;

        assembly{
             value := 0x64 //100
        }
        return value;
    }
}