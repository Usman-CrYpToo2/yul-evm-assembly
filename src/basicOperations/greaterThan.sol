// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;

contract greaterThan {
     
     function getGreaterThan ( ) pure  external  returns(bool ans) {
          
          assembly {
               let x := 100
               let y := 10
               ans := gt(x,y)
          }
     }
}