// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;

contract bytesToString{

    function returnStringWrong () pure external returns(string memory) { // this is not possible
         string memory data;

         assembly {
              data := "helloo"
         }
         return data;
    }

    function returnStringCorrect() pure external returns(string memory) {
        bytes32 toString ;

        assembly {
             toString := "hello world"
        }

        return string(abi.encode(toString));
    }



}