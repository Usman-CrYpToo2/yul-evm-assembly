// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;

contract packedSlots {
    //each slot is of 32 bytes
     uint128 a = 2; //-> 16 bytes
     uint128 b = 3; // -> 16 bytes
     //now the will pack these two variable in (a and b) in one slot;
    

     function getAandBslot() external pure returns(uint slotA,uint slotB) {
         assembly {
              slotA := a.slot
              slotB := b.slot //both are on the same slot
         }
     }

     function getAandBvalue ( ) external view returns(uint valA, uint valB){  // both will return a big value due to on the same slot
            assembly {
                valA := sload(a.slot)
                valB := sload(b.slot)
            }
     }

     // to get get packed slot value first we need to get in val in bytes
     // as they are on the same slot so we can get the val of any slot
     function getAslotinBytes (uint slotNo) external view returns(bytes32 slotValue) {
         assembly {
              slotValue :=sload(slotNo)
         }
     } 

  

     
}