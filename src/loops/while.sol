// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

//so there is no while loop in yul so we use for loop as while loop

contract whileLoop {
    function implementsWhileLoop() external pure returns (uint256 sum) {
        assembly {
            for { let i := 0 } lt(i, 10) {} {
                sum := add(sum, i)
                i := add(i, 1)
            }
        }
    }
}
