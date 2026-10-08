// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {offset as Offset} from "../src/packedSlots/offset.sol";
import {readingValue as ReadingValue} from "../src/packedSlots/readingValue.sol";
import {returnType256 as ReturnType256} from "../src/packedSlots/returnType256.sol";
import {writingInSlot as WritingInSlot} from "../src/packedSlots/writeInSlot.sol";

contract PackedSlotsTest is Test {
    WritingInSlot w;

    function setUp() public {
        w = new WritingInSlot(); // A=1, B=2, C=3, D=4, E=true, all packed in slot 0
    }

    function _assertSlot(uint128 a, uint96 b, uint16 c, uint8 d, bool e) internal view {
        assertEq(w.A(), a, "A changed");
        assertEq(w.B(), b, "B changed");
        assertEq(w.C(), c, "C changed");
        assertEq(w.D(), d, "D changed");
        assertEq(w.E(), e, "E changed");
    }

    function test_offsets() public {
        Offset o = new Offset();
        assertEq(o.AoffSet(), 0);
        assertEq(o.BoffSet(), 16);
    }

    function test_readPackedValues() public {
        ReadingValue r = new ReadingValue();
        assertEq(r.getAVal(), 1);
        assertEq(r.getBval(), 2);
        assertEq(r.getCval(), 3);
    }

    function test_maskedReads() public {
        ReturnType256 r = new ReturnType256();
        assertEq(r.getASlotVal(), 16);
        assertEq(r.getBSlotVal(), 30);
    }

    function test_writeEachVariable_leavesOthersUntouched() public {
        w.writeInAslot(type(uint128).max);
        _assertSlot(type(uint128).max, 2, 3, 4, true);
        w.writeInSlotB(type(uint96).max);
        _assertSlot(type(uint128).max, type(uint96).max, 3, 4, true);
        w.writeInSlotC(type(uint16).max);
        _assertSlot(type(uint128).max, type(uint96).max, type(uint16).max, 4, true);
        w.writeInSlotD(type(uint8).max);
        _assertSlot(type(uint128).max, type(uint96).max, type(uint16).max, type(uint8).max, true);
    }

    /// Writing E must not touch D. Uses a D value with the high 4 bits set,
    /// which is exactly what a one-digit-short mask would clear.
    function test_writeE_doesNotCorruptD() public {
        w.writeInSlotD(0xF4);
        w.writeInSlotE(false);
        _assertSlot(1, 2, 3, 0xF4, false);
        w.writeInSlotE(true);
        _assertSlot(1, 2, 3, 0xF4, true);
    }

    /// Writing a full word into a packed slot wipes every variable in it.
    /// That is the point this function demonstrates.
    function test_fullWordWrite_overwritesWholeSlot() public {
        w.onlyWorkWith2256(7);
        assertEq(w.A(), 7);
        assertEq(w.B(), 0);
        assertEq(w.E(), false);
    }
}
