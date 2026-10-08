// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

contract hexToUnit {
    function hexToUnitAssigned() external pure returns (uint256) {
        uint256 value;

        assembly {
            value := 0x64 //100
        }
        return value;
    }
}
