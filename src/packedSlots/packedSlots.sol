// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

contract packed {
    uint128 public A = 1; // 16 bytes
    uint96 public B = 2; // 12 bytes
    uint16 public C = 4; // 2 bytes;
    uint8 public D = 5; // 1 bytes
    bool public F = true; // 1 bytes;

    function unableToRead() external view returns (uint256 val) {
        assembly {
            val := sload(A.slot)
        }
    }

    function readingSlot() external view returns (bytes32 slotVal) {
        assembly {
            slotVal := sload(A.slot)
        }
    }
}
