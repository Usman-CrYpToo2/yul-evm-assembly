// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

contract readingState {
    uint256 x = 12;

    function getXinYul() external view returns (uint256 val) {
        assembly {
            val := sload(x.slot)
        }
    }

    function setXinYul(uint256 _x) external {
        assembly {
            sstore(x.slot, _x)
        }
    }
}
