// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;

contract readingSlots {
    
     uint x = 21;
     uint y = 42;
     uint z = 12;
     uint private pri = 69;

    function xSlot() external pure returns(uint slot) {
        assembly {
             slot := x.slot
        }
    }

    function ySlot() external  pure returns(uint slot) {
         assembly {
              slot := y.slot
         }
    }

    function zSlot() external pure returns(uint slot) {
        assembly {
            slot := z.slot
        }
    }

    function priSlot() external pure returns(uint slot) {
      assembly {
           slot := pri.slot
      }
    }

    function getSlotValue(uint slotNo) external view returns(uint value) {
        assembly {
            value := sload(slotNo)
        }
    }

}