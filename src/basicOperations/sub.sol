// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;

contract sub{

    function subtraction() pure external  returns(uint z) {
        assembly{
            let x := 4
            let y := 2
            
            z := sub(x,y)
        }
    }
}