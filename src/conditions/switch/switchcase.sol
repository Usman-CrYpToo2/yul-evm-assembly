// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

contract switchs {
    function calculator(int256 x, int256 y, uint256 op) external pure returns (int256 ans) {
        assembly {
            switch op
            case 1 {
                ans := add(x, y)
            }

            case 2 {
                ans := sub(x, y)
            }

            case 3 {
                ans := mul(x, y)
            }

            // x and y are signed, so use sdiv and smod. Plain div and mod
            // read a negative number as a huge positive one.
            // The EVM returns 0 on division by zero, so revert explicitly.
            case 4 {
                if iszero(y) { revert(0, 0) }
                ans := sdiv(x, y)
            }

            case 5 {
                if iszero(y) { revert(0, 0) }
                ans := smod(x, y)
            }

            default {
                revert(0, 0)
            }
        }
    }
}
