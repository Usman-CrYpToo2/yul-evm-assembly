// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";

import {add as Add} from "../src/basicOperations/add.sol";
import {sub as Sub} from "../src/basicOperations/sub.sol";
import {mul as Mul} from "../src/basicOperations/mul.sol";
import {div as Div} from "../src/basicOperations/div.sol";
import {mod as Mod} from "../src/basicOperations/mod.sol";
import {greaterThan as Gt} from "../src/basicOperations/greaterThan.sol";
import {lessthan as Lt} from "../src/basicOperations/lessThan.sol";
import {iszero as IsZero} from "../src/basicOperations/iszero.sol";

import {ifCondition as IfCondition} from "../src/conditions/if/ifCondition.sol";
import {max as Max} from "../src/conditions/if/max.sol";
import {min as Min} from "../src/conditions/if/min.sol";
import {switchs as Switch} from "../src/conditions/switch/switchcase.sol";

import {forLoop as ForLoop} from "../src/loops/for.sol";
import {whileLoop as WhileLoop} from "../src/loops/while.sol";
import {isPrime as IsPrime} from "../src/loops/isPrime.sol";

import {byteToaddress as AddrContract} from "../src/dataType/address.sol";
import {byteTobool as BoolType} from "../src/dataType/bool.sol";
import {yulDataType as WordType} from "../src/dataType/byte32.sol";
import {bytesToString as StringType} from "../src/dataType/bytes32ToString.sol";
import {hexToUnit as HexType} from "../src/dataType/hexToUnit.sol";

import {readingState as ReadingState} from "../src/stateVariables/readingSlot.sol";
import {readingSlots as ReadingSlots} from "../src/stateVariables/readingSlots.sol";
import {writeSlot as WriteSlot} from "../src/stateVariables/writeSlots.sol";
import {packedSlots as PackedPair} from "../src/stateVariables/packedSlot.sol";

contract BasicOperationsTest is Test {
    function test_arithmetic() public {
        assertEq(new Add().adding(), 6);
        assertEq(new Sub().subtraction(), 2);
        assertEq(new Mul().multiplication(), 8);
        assertEq(new Div().division(), 5);
        assertEq(new Mod().getMod(), 9);
    }

    function test_comparisons() public {
        assertTrue(new Gt().getGreaterThan());
        assertTrue(new Lt().getLessThan());
        assertTrue(new IsZero().checkIszero());
    }
}

contract ConditionsTest is Test {
    Switch calc;

    function setUp() public {
        calc = new Switch();
    }

    function test_if() public {
        assertEq(new IfCondition().checkIf(), 32);
        assertEq(new Max().maxi(), 500);
        assertEq(new Min().mini(), 50);
    }

    function test_switch_addSubMul_signed() public view {
        assertEq(calc.calculator(7, 3, 1), 10);
        assertEq(calc.calculator(2, 3, 2), -1);
        assertEq(calc.calculator(-7, 3, 3), -21);
    }

    /// Signed inputs need sdiv and smod. Plain div and mod treat a negative
    /// number as a huge positive one.
    function test_switch_divMod_signed() public view {
        assertEq(calc.calculator(7, 2, 4), 3);
        assertEq(calc.calculator(-7, 2, 4), -3);
        assertEq(calc.calculator(7, -2, 4), -3);
        assertEq(calc.calculator(7, 3, 5), 1);
        assertEq(calc.calculator(-7, 3, 5), -1);
    }

    /// The EVM returns 0 when dividing by zero. Solidity reverts instead,
    /// so the calculator should too.
    function test_switch_divisionByZeroReverts() public {
        vm.expectRevert();
        calc.calculator(7, 0, 4);
        vm.expectRevert();
        calc.calculator(7, 0, 5);
    }

    function test_switch_unknownOpReverts() public {
        vm.expectRevert();
        calc.calculator(7, 3, 9);
    }
}

contract LoopsTest is Test {
    function test_sumLoops() public {
        assertEq(new ForLoop().implementFor(), 45);
        assertEq(new WhileLoop().implementsWhileLoop(), 45);
    }

    function test_isPrime() public {
        IsPrime p = new IsPrime();
        assertFalse(p.findIsPrime(0));
        assertFalse(p.findIsPrime(1));
        assertTrue(p.findIsPrime(2));
        assertTrue(p.findIsPrime(3));
        assertFalse(p.findIsPrime(4));
        assertFalse(p.findIsPrime(9));
        assertTrue(p.findIsPrime(13));
        assertTrue(p.findIsPrime(97));
        assertFalse(p.findIsPrime(100));
    }
}

contract DataTypesTest is Test {
    function test_wordTypes() public {
        assertEq(new AddrContract().addressDatatype(), address(10));
        assertEq(new WordType().getUnit256(), 100);
        assertEq(new HexType().hexToUnitAssigned(), 100);
    }

    function test_bool() public {
        BoolType b = new BoolType();
        assertTrue(b.returnTrue());
        assertFalse(b.returnFalse());
        assertTrue(b.bytes32TOBoolTrue());
        assertFalse(b.bytes32ToBoolFalse());
    }

    function test_string() public {
        StringType s = new StringType();
        bytes memory out = bytes(s.returnStringCorrect());
        assertEq(out.length, 32, "a bytes32 always becomes 32 bytes");
        // forge-lint: disable-next-line(unsafe-typecast)
        assertEq(bytes11(out), bytes11("hello world")); // intentional: compare only the 11 text bytes
    }

    /// Assigning a string literal to a memory string in assembly stores the
    /// literal as the memory pointer, so returning it reads from a nonsense
    /// address and runs out of gas.
    function test_string_wrongWayReverts() public {
        StringType s = new StringType();
        vm.expectRevert();
        s.returnStringWrong();
    }
}

contract StateVariablesTest is Test {
    function test_readWrite() public {
        ReadingState r = new ReadingState();
        assertEq(r.getXinYul(), 12);
        r.setXinYul(55);
        assertEq(r.getXinYul(), 55);

        WriteSlot w = new WriteSlot();
        w.setX(9);
        assertEq(w.x(), 9);
    }

    function test_slotNumbers() public {
        ReadingSlots r = new ReadingSlots();
        assertEq(r.xSlot(), 0);
        assertEq(r.ySlot(), 1);
        assertEq(r.zSlot(), 2);
        assertEq(r.priSlot(), 3);
        assertEq(r.getSlotValue(3), 69, "private only hides it from Solidity, not from storage");
    }

    function test_twoVariablesShareASlot() public {
        PackedPair p = new PackedPair();
        (uint256 a, uint256 b) = p.getAandBslot();
        assertEq(a, 0);
        assertEq(b, 0);
    }
}
