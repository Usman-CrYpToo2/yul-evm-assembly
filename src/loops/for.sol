// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;

contract forLoop{
    function implementFor() pure external returns(uint sum) {
        assembly {
            
            for {let i := 0} lt(i, 10) {i := add(i,1)} {
                sum := add(sum, i)
            }
     

        }
    }
}