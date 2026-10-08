// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;

contract byteToaddress{

    function addressDatatype() pure external returns(address){
         address addr;

         assembly {
              addr := 10
         }

         return addr;
    }
}