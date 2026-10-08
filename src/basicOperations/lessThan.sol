// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;

contract lessthan {

    function getLessThan ( ) pure external returns(bool ans) {
         assembly {
              let x := 10
              let y := 100
              ans := lt(x,y)
         }
    }
}