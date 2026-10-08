// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;

contract min {

    function mini () pure external returns(uint minNum) {
        assembly {
             let x := 50
             let y := 100

             if lt(x, y) {
                 minNum := x
             }

             if iszero( lt(x, y) ) {
                 minNum := y
             }
        }
    }
}