// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

contract writingInSlot {
    uint128 public A = 1; // 16 bytes
    uint96 public B = 2; // 12 bytes
    uint16 public C = 3;
    uint8 public D = 4;
    bool public E = true;

    function onlyWorkWith2256(uint256 _num) external {
        assembly {
            let Cslot := C.slot
            sstore(Cslot, _num) // not going to work with the anyother data type;
        }
    }

    function writeInAslot(uint128 _Anew) external {
        assembly {
            let Aslot := sload(A.slot)
            let Aoffset := A.offset

            let leftShiftNewA := shl(mul(Aoffset, 8), _Anew)

            let clearA := 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000

            let clearAslot := and(clearA, Aslot)

            let newValue := or(clearAslot, leftShiftNewA)

            sstore(A.slot, newValue)
        }
    }

    function writeInSlotB(uint96 _Bnew) external {
        assembly {
            let Bslot := sload(B.slot)
            let Boffset := B.offset // bytes

            let leftShitfNewB := shl(mul(Boffset, 8), _Bnew)

            let clearB := 0xffffffff000000000000000000000000ffffffffffffffffffffffffffffffff

            let clearBslot := and(clearB, Bslot)

            let BnewValue := or(clearBslot, leftShitfNewB)

            sstore(B.slot, BnewValue)
        }
    }

    function writeInSlotC(uint16 _Cnew) external {
        assembly {
            let Cslot := sload(C.slot)
            let Coffset := C.offset

            let leftShiftNewC := shl(mul(Coffset, 8), _Cnew)

            let clearC := 0xffff0000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff

            let clearCslot := and(clearC, Cslot)

            let newValue := or(clearCslot, leftShiftNewC)

            sstore(C.slot, newValue)
        }
    }

    function writeInSlotD(uint8 _Dnew) external {
        assembly {
            let Dslot := sload(D.slot)
            let Doffset := D.offset

            let leftShiftD := shl(mul(Doffset, 8), _Dnew)

            let clearD := 0xff00ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
            let clearDslot := and(clearD, Dslot)

            let newValue := or(clearDslot, leftShiftD)

            sstore(D.slot, newValue)
        }
    }

    function writeInSlotE(bool _Enew) external {
        assembly {
            let Eslot := sload(E.slot)
            let Eoffset := E.offset

            let leftShiftnewE := shl(mul(Eoffset, 8), _Enew)

            // 64 hex digits: clears only the top byte (E), keeps D intact
            let clearE := 0x00ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
            let clearEslot := and(clearE, Eslot)

            let newValue := or(clearEslot, leftShiftnewE)

            sstore(E.slot, newValue)
        }
    }

    function readTheSlot() external view returns (bytes32 Slot) {
        assembly {
            Slot := sload(0)
        }
    }
}
