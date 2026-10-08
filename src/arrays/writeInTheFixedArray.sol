// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;

contract writingInFixedArray {
      uint256[5] public arr;

      function writeInArray(uint index, uint val) external {
           assembly {
               // without this, index 5+ writes into storage slots past the array
               if iszero(lt(index, 5)) { revert(0, 0) }
               let arrSlot := arr.slot
               let indexSlot := add(arrSlot,index)

                sstore(indexSlot,val)
           }
      }
}