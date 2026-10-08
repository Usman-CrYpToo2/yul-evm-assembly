// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

contract readingSlots {
    uint256 x = 21;
    uint256 y = 42;
    uint256 z = 12;
    uint256 private pri = 69;

    function xSlot() external pure returns (uint256 slot) {
        assembly {
            slot := x.slot
        }
    }

    function ySlot() external pure returns (uint256 slot) {
        assembly {
            slot := y.slot
        }
    }

    function zSlot() external pure returns (uint256 slot) {
        assembly {
            slot := z.slot
        }
    }

    function priSlot() external pure returns (uint256 slot) {
        assembly {
            slot := pri.slot
        }
    }

    function getSlotValue(uint256 slotNo) external view returns (uint256 value) {
        assembly {
            value := sload(slotNo)
        }
    }
}
