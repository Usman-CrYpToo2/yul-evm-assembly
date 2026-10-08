// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;

contract packed {
      uint128 public A = 1; // 16 bytes
      uint96 public B = 2; // 12 bytes
      uint16 public C = 4 ; // 2 bytes;
      uint8 public D = 5;  // 1 bytes
     bool public F =  true ; // 1 bytes;

     function unableToRead() view external returns(uint val) {
         assembly {
              val := sload(A.slot)
         }
     }

     function readingSlot() view external returns(bytes32 slotVal) {
          assembly {
               slotVal := sload(A.slot)
          }
     }
}