// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;

contract isPrime {
    
     function findIsPrime(uint num) pure external  returns(bool ans) {
         assembly {
             ans := true
               if or( lt(num, 1), eq(num, 1)) {
                ans := false
                
             }
              let half := add( div(num, 2), 1)
              
             for {let i := 2} lt(i, half) {i := add(i,1)} {
                 
                  if iszero(mod(num, i)) {
                      ans := false
                      break
                  }
             }

             
         }
     }
}