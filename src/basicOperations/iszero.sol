// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;

contract iszero{

    function checkIszero () pure external  returns(bool ans) {
        bytes32 get;
         assembly {
              let num := 0
              get := iszero(num)
              ans := get
         }
        
    }
}