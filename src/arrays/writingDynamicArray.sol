// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

contract WritingInDynamicArray {
    uint256[] public arr;
     
     function incrementSlot(uint256 size) internal {
         assembly {
              let arraySlot := arr.slot
              sstore(arraySlot, size)
         }
     }

     function writeIn(uint val) external {
           uint256 len;
           uint256 slot;
           assembly{
                len := sload(arr.slot)
                slot := arr.slot
           }
            
            incrementSlot(len + 1);

            bytes32 location = keccak256(abi.encode(slot));

            assembly{
                 sstore(add(location, len), val)
            }
     }
}
