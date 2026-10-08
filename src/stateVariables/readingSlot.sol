// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;

contract readingState {
     
     uint x = 12;

    function getXinYul() external view returns(uint val){
         assembly {
            val := sload(x.slot)
         }
     }

     function setXinYul(uint _x) external {
         assembly {
            sstore(x.slot,_x) 
         }
     }
}