// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;

contract readSmallArray {
      uint16[3] public arr = [1,2,3];

      function getIndexVal(uint256 index) external view returns(uint16 val) {
           assembly {
               if iszero(lt(index, 3)) { revert(0, 0) } // arr has 3 elements
               let arraySlot := arr.slot
            let  slot := sload(arraySlot)
                
             let offset := mul(2, 8) // as the 2 bytes 

             let getIndexOffset := mul(offset, index)

             // shifting leaves the higher elements in the upper bits, so mask to 16 bits
             val := and(shr(getIndexOffset, slot), 0xffff)

           }
      }




      function readSlot() external view returns(bytes32 slot) {
            assembly {
                 let slotNo := arr.slot
                 
                 slot := sload(slotNo)

            }
      }      
}