// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;

contract div{
  

   function division () pure external  returns(uint z) {
        assembly {
             let x := 0xA
             let y := 2
             z := div(x,y)
        }
   } 
}