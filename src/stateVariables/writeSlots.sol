// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

contract writeSlot {
    uint256 public x;

    function setX(uint256 _x) external {
        assembly {
            sstore(x.slot, _x)
        }
    }
}
