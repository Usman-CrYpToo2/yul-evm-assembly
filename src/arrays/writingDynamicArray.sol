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

    function writeIn(uint256 val) external {
        uint256 len;
        uint256 slot;
        assembly {
            len := sload(arr.slot)
            slot := arr.slot
        }

        incrementSlot(len + 1);

        bytes32 location;
        assembly {
            // data starts at keccak256(slot)
            mstore(0x00, slot)
            location := keccak256(0x00, 0x20)
        }

        assembly {
            sstore(add(location, len), val)
        }
    }
}
