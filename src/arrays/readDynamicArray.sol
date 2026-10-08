// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;

contract readingDynamicArray {
       // this is a dynamic array;
       uint256[] arr = [1,2,3,4,5];  // the array will be on slot 0  // but the values in array is not on the slot 0
       

       function getArraySlot() external view returns(uint256 slotVal) {
         assembly {
            let slot := arr.slot // this will return 0 because the array is on zero slot 

            slotVal := sload(slot) // this will return the length of the array;
         }
       }

       function readingTheValue(uint index) view external returns(uint256 val) {
           uint256 slot ;
           assembly {
              slot := arr.slot
              if iszero(lt(index, sload(slot))) { revert(0, 0) } // slot holds the length
           }

           bytes32 location = keccak256(abi.encode(slot)); // this will return the Location of First Value in array
           
           assembly{
               let indexSlot := add(location, index)

               val := sload(indexSlot)
           }
       }
}