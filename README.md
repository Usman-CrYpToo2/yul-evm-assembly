# Yul and EVM Assembly Notes

[![test](https://github.com/Usman-CrYpToo2/yul-evm-assembly/actions/workflows/test.yml/badge.svg)](https://github.com/Usman-CrYpToo2/yul-evm-assembly/actions/workflows/test.yml)

Small, focused Solidity contracts that each show one idea in inline assembly (Yul): arithmetic, control flow, how storage slots are laid out, how packed variables share a slot, and how arrays are stored.

I wrote these in 2023 while learning Yul. In 2026 I went back over them as an auditor, added a Foundry test suite, and fixed the bugs the tests exposed. Those fixes are listed [below](#bugs-found-in-review).

## Contents

All contracts are in [`src/`](src), grouped by topic.

| Topic | File | What it shows |
|---|---|---|
| **Basic operations** | [`basicOperations/`](src/basicOperations) | `add`, `sub`, `mul`, `div`, `mod`, `gt`, `lt`, `iszero` |
| **Conditions** | [`conditions/if/`](src/conditions/if) | `if` blocks, and building `max` and `min` without an `else` |
| | [`conditions/switch/switchcase.sol`](src/conditions/switch/switchcase.sol) | A signed calculator with `switch`, `sdiv`, `smod`, and a `default` that reverts |
| **Loops** | [`loops/for.sol`](src/loops/for.sol) | A `for` loop |
| | [`loops/while.sol`](src/loops/while.sol) | Yul has no `while`, so a `for` loop with an empty post block plays that role |
| | [`loops/isPrime.sol`](src/loops/isPrime.sol) | Trial division with `break` |
| **Data types** | [`dataType/`](src/dataType) | Yul has one type, the 256-bit word. Assigning words to `address`, `bool`, and `uint`, and why returning a string needs care |
| **State variables** | [`stateVariables/`](src/stateVariables) | `.slot` to find a variable, `sload` and `sstore` to read and write it, and reading a `private` variable straight from storage |
| **Packed slots** | [`packedSlots/offset.sol`](src/packedSlots/offset.sol) | `.offset`: where a small variable starts inside its slot |
| | [`packedSlots/readingValue.sol`](src/packedSlots/readingValue.sol) | Reading one packed variable: shift right by its offset, then mask |
| | [`packedSlots/returnType256.sol`](src/packedSlots/returnType256.sol) | Why the mask matters when the return type is a full `uint256` |
| | [`packedSlots/writeInSlot.sol`](src/packedSlots/writeInSlot.sol) | Writing one packed variable without touching its neighbours: clear its bits with a mask, shift the new value in, `or` them together |
| **Arrays** | [`arrays/readingFixedArray.sol`](src/arrays/readingFixedArray.sol), [`writeInTheFixedArray.sol`](src/arrays/writeInTheFixedArray.sol) | Fixed arrays take consecutive slots starting at `arr.slot` |
| | [`arrays/readDynamicArray.sol`](src/arrays/readDynamicArray.sol), [`writingDynamicArray.sol`](src/arrays/writingDynamicArray.sol) | Dynamic arrays keep their length at `arr.slot` and their data at `keccak256(arr.slot)` |
| | [`arrays/readingSmallBytesArray.sol`](src/arrays/readingSmallBytesArray.sol) | Small elements (`uint16`) are packed several to a slot |

## Running the tests

You need [Foundry](https://book.getfoundry.sh/getting-started/installation).

```bash
git clone --recurse-submodules https://github.com/Usman-CrYpToo2/yul-evm-assembly.git
cd yul-evm-assembly
forge test
```

There are 31 tests in [`test/`](test), one or more for every contract.

## Bugs found in review

These are the bugs the tests caught. Each is fixed and covered by a test.

| Bug | Where | What went wrong |
|---|---|---|
| Writing `E` corrupted `D` | `packedSlots/writeInSlot.sol` | The mask for `E` had 63 hex digits instead of 64. A short hex literal is padded on the left, so the mask cleared the top 4 bits of `D` as well as `E`. Writing `E` changed `D` from `0xF4` to `0x04`. |
| Signed division was wrong | `conditions/switch/switchcase.sol` | The calculator takes `int` inputs but used `div` and `mod`, which are unsigned. Its "both positive" guard used `gt`, also unsigned, so negative numbers passed the guard as huge positive ones. `-7 / 2` returned about 5.8 × 10^76. Fixed with `sdiv` and `smod`. |
| Division by zero returned 0 | `conditions/switch/switchcase.sol` | The EVM returns 0 instead of reverting. Solidity would revert, so the assembly now does too. |
| Unknown operation returned 0 | `conditions/switch/switchcase.sol` | No `default` case. It now reverts. |
| Writing past a fixed array | `arrays/writeInTheFixedArray.sol` | No bounds check, so index 5 of a `uint256[5]` wrote into storage slot 5, which belongs to whatever variable comes next. |
| Reading past arrays | `arrays/readingFixedArray.sol`, `readDynamicArray.sol`, `readingSmallBytesArray.sol` | Out-of-range reads returned neighbouring storage, or 0, instead of reverting. |
| Packed reads not masked | `arrays/readingSmallBytesArray.sol`, `packedSlots/readingValue.sol` | After shifting, the other packed values were still in the upper bits. The ABI encoder happened to clean them on return, but assembly should not rely on that. |
| Wrong `bool` source | `dataType/bool.sol` | `bytes32 rTrue = "0x1"` is the text `0x1`, not the number 1. |

Also removed: a duplicate `conditions/iszero.sol` that never assigned its return value.

## Notes

- `add`, `sub`, and `mul` in assembly wrap around on overflow instead of reverting. That is expected, and the reason Solidity 0.8 adds checks around them.
- `writeInSlot.onlyWorkWith2256` deliberately writes a full word into a packed slot, to show how that wipes every variable sharing it.
- `bytes32ToString.returnStringWrong` deliberately fails, to show that a string literal assigned in assembly becomes a memory pointer, not a string.

## License

MIT, see [LICENSE](LICENSE).
