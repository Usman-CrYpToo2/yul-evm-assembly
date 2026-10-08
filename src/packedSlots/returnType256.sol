// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;

contract returnType256 {
   
     uint16 public a  = 16;
     uint16 public b = 30;

     function getASlotVal () external view returns(uint256 Aval) {
         
         assembly {
               let Aslot := sload(a.slot)
                
                let  _a :=0xffff
               Aval := and(Aslot, _a)    
         }
     }

     function getBSlotVal() external view returns(uint256 Bval) {
         assembly {
             let Bslot := sload(b.slot)
             let Boffset:= b.offset // in bytes

             let offsetInBits := mul(Boffset, 8) // in bits
              
             let shifting := shr(offsetInBits, Bslot)

             let _b := 0xffff

             Bval := and(_b, shifting)

         }
     }
}