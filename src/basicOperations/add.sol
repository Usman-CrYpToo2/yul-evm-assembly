// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

contract add {
    function adding() external pure returns (uint256 z) {
        uint256 x = 2;
        uint256 y = 4;

        assembly {
            let addition := add(x, y)

            z := addition
        }
    }
}
