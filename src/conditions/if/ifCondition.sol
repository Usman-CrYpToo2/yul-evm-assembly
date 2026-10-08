// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;


contract ifCondition {
 

    function checkIf() pure external  returns(uint) {
        uint ans ;
        assembly{
             let x := 32
             if gt(x,0)  {
                 ans := x
             }
        }

        return ans;
    
}

}