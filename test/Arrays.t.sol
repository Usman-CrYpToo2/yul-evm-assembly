// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {readArray as ReadFixedArray} from "../src/arrays/readingFixedArray.sol";
import {writingInFixedArray as WriteFixedArray} from "../src/arrays/writeInTheFixedArray.sol";
import {readingDynamicArray as ReadDynamicArray} from "../src/arrays/readDynamicArray.sol";
import {WritingInDynamicArray as WriteDynamicArray} from "../src/arrays/writingDynamicArray.sol";
import {readSmallArray as ReadSmallArray} from "../src/arrays/readingSmallBytesArray.sol";

contract ArraysTest is Test {
    function test_readFixedArray() public {
        ReadFixedArray a = new ReadFixedArray();
        for (uint256 i; i < 5; i++) {
            assertEq(a.getIndexValue(i), i + 1);
        }
    }

    function test_readFixedArray_outOfBoundsReverts() public {
        ReadFixedArray a = new ReadFixedArray();
        vm.expectRevert();
        a.getIndexValue(5);
    }

    function test_writeFixedArray() public {
        WriteFixedArray a = new WriteFixedArray();
        a.writeInArray(4, 99);
        assertEq(a.arr(4), 99);
    }

    /// Index 5 is past the end of a uint256[5]. Without a bounds check the
    /// write lands in storage slot 5, which belongs to whatever comes next.
    function test_writeFixedArray_outOfBoundsReverts() public {
        WriteFixedArray a = new WriteFixedArray();
        vm.expectRevert();
        a.writeInArray(5, 99);
        assertEq(vm.load(address(a), bytes32(uint256(5))), bytes32(0));
    }

    function test_readDynamicArray() public {
        ReadDynamicArray a = new ReadDynamicArray();
        assertEq(a.getArraySlot(), 5, "slot holds the length");
        for (uint256 i; i < 5; i++) {
            assertEq(a.readingTheValue(i), i + 1);
        }
    }

    function test_readDynamicArray_outOfBoundsReverts() public {
        ReadDynamicArray a = new ReadDynamicArray();
        vm.expectRevert();
        a.readingTheValue(5);
    }

    function test_writeDynamicArray_pushes() public {
        WriteDynamicArray a = new WriteDynamicArray();
        a.writeIn(7);
        a.writeIn(8);
        assertEq(a.arr(0), 7);
        assertEq(a.arr(1), 8);
        vm.expectRevert();
        a.arr(2);
    }

    function test_readSmallArray() public {
        ReadSmallArray a = new ReadSmallArray();
        assertEq(a.getIndexVal(0), 1);
        assertEq(a.getIndexVal(1), 2);
        assertEq(a.getIndexVal(2), 3);
    }

    function test_readSmallArray_outOfBoundsReverts() public {
        ReadSmallArray a = new ReadSmallArray();
        vm.expectRevert();
        a.getIndexVal(3);
    }
}
