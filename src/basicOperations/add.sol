// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;

contract add{
    
    function adding() external  pure returns(uint z) {
        uint x = 2;
        uint y = 4;

        assembly{
            let addition := add(x,y)
            
            z := addition

        }
    }
}