// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;

contract writeSlot {
     uint public x;

     function setX(uint _x) external {
         assembly {
             sstore(x.slot, _x)
         }
     }
}