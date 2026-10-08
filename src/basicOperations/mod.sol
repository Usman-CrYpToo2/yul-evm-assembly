// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

contract mod {
    function getMod() external pure returns (uint256 rem) {
        assembly {
            let x := 99
            let y := 10
            rem := mod(x, y)
        }
    }
}
