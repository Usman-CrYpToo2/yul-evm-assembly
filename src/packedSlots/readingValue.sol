// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;

contract readingValue {
     uint128 public A = 1; // 16 bytes
     uint96 public B = 2; // 12 bytes 
     uint32 public C = 3; // 4 bytes;

     function getSlotsVal() external view returns(bytes32 Aval, bytes32 Bval, bytes32 Cval) {
         assembly {
              Aval := sload(A.slot)
              Bval := sload(B.slot)
              Cval := sload(C.slot)
         }
     }
      
      //in one slot 0x0000000300000000000000000000000200000000000000000000000000000001

     function getAVal() external view returns(uint128 Aval) {
         assembly {
             let Aslot := sload(A.slot)
             let Aoffset := A.offset // 0

             let offsetInBits := mul(Aoffset, 8) // 0 x 8 = 0

             // B and C sit in the upper bits too, so mask to A's 16 bytes
             Aval := and(shr(offsetInBits, Aslot), 0xffffffffffffffffffffffffffffffff)  // 0x0000000300000000000000000000000200000000000000000000000000000001
         }
     }

     function getBval() external view returns(uint96 Bval){
         assembly {
             let Bslot := sload(B.slot)
             let Boffset := B.offset

             let offsetInBits := mul(Boffset, 8)

             // C sits above B, so mask to B's 12 bytes
             Bval := and(shr(offsetInBits, Bslot), 0xffffffffffffffffffffffff)
         }
     }

     function getCval() external view returns(uint32 Cval) {
         assembly {
              let Cslot := sload(C.slot)  
              let Coffset := C.offset  // 28

              let offsetInBits  := mul(Coffset, 8) // 28 x 8 = 224

              Cval := shr(offsetInBits, Cslot) //0x0000000000000000000000000000000000000000000000000000000000000003
         }
     }

}