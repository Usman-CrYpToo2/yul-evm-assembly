// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;

contract max {
 
   function maxi() pure external returns(uint maxNum) {
        
        assembly {
          let x := 500
          let y := 100

          if gt(x, y) {
               maxNum := x
          }      

          if iszero( gt(x,y) ) {
              maxNum := y
          }  

        }
   }

}