// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;

contract offset {
     uint128 public A = 100;
     uint128 public B = 200;

     function getSlot() external view returns(bytes32 valA, bytes32 valB) {
       assembly {
         valA := sload(A.slot)
         valB := sload(B.slot)
       }
     } 

     function AoffSet() external pure returns(uint location){
        assembly {
             location := A.offset
        }
     }

     function BoffSet() external  pure returns(uint location) {
         assembly {
              location := B.offset
         }
     }
}