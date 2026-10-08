// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

contract mul {
    function multiplication() external pure returns (uint256 z) {
        assembly {
            let x := 2
            let y := 4
            z := mul(x, y)
        }
    }
}
