// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

contract div {
    function division() external pure returns (uint256 z) {
        assembly {
            let x := 0xA
            let y := 2
            z := div(x, y)
        }
    }
}
