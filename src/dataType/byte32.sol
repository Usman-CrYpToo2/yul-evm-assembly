// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

contract yulDataType{
 
 // Yul has only one type: the 256-bit (32-byte) word.
 // Every Solidity value, whether uint, address, bool, or bytes32, is handled as that word inside assembly.

   function getUnit256() pure external returns(uint256){
        uint value;
         assembly{
              value := 100
         }

         return value ;
   }

}