# Yul EVM Assembly

[![test](https://github.com/Usman-CrYpToo2/yul-evm-assembly/actions/workflows/test.yml/badge.svg)](https://github.com/Usman-CrYpToo2/yul-evm-assembly/actions/workflows/test.yml)

Minimal contracts covering EVM storage layout and control flow in inline assembly (Yul). Each contract isolates a single concept and is covered by a Foundry test.

> [!WARNING]
> Educational code. Unaudited and not intended for deployment.

## Contents

All sources are under [`src/`](src).

| Topic | Source | Concept |
|---|---|---|
| Arithmetic and comparison | [`basicOperations/`](src/basicOperations) | `add`, `sub`, `mul`, `div`, `mod`, `gt`, `lt`, `iszero` |
| Conditionals | [`conditions/if/`](src/conditions/if) | `if` without `else`; `max` and `min` |
| | [`conditions/switch/switchcase.sol`](src/conditions/switch/switchcase.sol) | Signed arithmetic with `switch`, `sdiv`, `smod`, and a reverting `default` |
| Loops | [`loops/`](src/loops) | `for`; `while` expressed as `for` with an empty post block; early `break` |
| Data types | [`dataType/`](src/dataType) | The single 256-bit word type and its interpretation as `address`, `bool`, `uint256`, `bytes32` |
| State variables | [`stateVariables/`](src/stateVariables) | `.slot`, `sload`, `sstore`; reading `private` state directly from storage |
| Packed slots | [`packedSlots/`](src/packedSlots) | `.offset`; read with shift and mask; write with clear, shift, and `or` |
| Arrays | [`arrays/`](src/arrays) | Fixed, dynamic, and packed (`uint16[]`) array layout |

## Storage Layout Reference

| Layout | Location of element `i` |
|---|---|
| Value type at slot `p` | `p` |
| Fixed array `T[n]` at slot `p`, 32-byte elements | `p + i` |
| Dynamic array `T[]` at slot `p` | length at `p`; element at `keccak256(p) + i` |
| Packed variable at slot `p`, byte offset `o`, width `w` bytes | `(sload(p) >> (8 * o)) & (2^(8w) - 1)` |

## Usage

Requires [Foundry](https://book.getfoundry.sh/getting-started/installation).

```bash
git clone --recurse-submodules https://github.com/Usman-CrYpToo2/yul-evm-assembly.git
cd yul-evm-assembly
forge test
```

The suite contains 31 tests. CI runs `forge fmt --check`, `forge build`, and `forge test` on every push.

## Security Review

Issues identified by the test suite and resolved in [`a079d70`](https://github.com/Usman-CrYpToo2/yul-evm-assembly/commit/a079d70). Each is covered by a regression test.

| ID | Severity | Title | Location |
|---|---|---|---|
| H-01 | High | Out-of-bounds write corrupts adjacent storage | `arrays/writeInTheFixedArray.sol` |
| H-02 | High | Clear mask for `E` also clears the upper nibble of `D` | `packedSlots/writeInSlot.sol` |
| M-01 | Medium | Unsigned `div` and `mod` applied to signed operands | `conditions/switch/switchcase.sol` |
| L-01 | Low | Out-of-bounds reads return adjacent storage or zero | `arrays/*.sol` |
| L-02 | Low | Division by zero and unknown operations return zero | `conditions/switch/switchcase.sol` |
| L-03 | Low | Packed values returned without masking | `arrays/readingSmallBytesArray.sol`, `packedSlots/readingValue.sol` |
| I-01 | Info | `bool` source initialised from a string literal | `dataType/bool.sol` |

**H-01.** `writeInArray` stored at `arr.slot + index` with no bound, so `index >= 5` wrote into slots owned by subsequent state variables. *Fix:* revert when `index >= 5`.

**H-02.** The mask was a 63-digit literal, which the compiler left-pads to `0x000fff...`. Clearing with it zeroed bits 244 to 255, covering `E` and the upper nibble of `D`. Writing `E` changed `D` from `0xF4` to `0x04`. *Fix:* 64-digit mask `0x00ff...ff`.

**M-01.** The calculator accepts `int256` but used `div` and `mod`. The guard `and(gt(x, 0), gt(y, 0))` is also unsigned, so negative operands passed it as large positive values; `-7 / 2` returned approximately `5.79e76`. *Fix:* `sdiv` and `smod`.

**L-01.** Reads past the end of fixed, dynamic, and packed arrays returned neighbouring storage or zero instead of reverting. *Fix:* bounds checks against the declared length or the stored length.

**L-02.** The EVM returns zero on division by zero, and the `switch` had no `default`. *Fix:* explicit reverts for both.

**L-03.** After `shr`, neighbouring packed values remained in the upper bits. Results were correct only because the ABI encoder cleans return values. *Fix:* mask to the variable's width.

**I-01.** `bytes32 rTrue = "0x1"` encodes the ASCII string `0x1`, not the integer `1`. *Fix:* `bytes32(uint256(1))`.

## Notes

- Assembly `add`, `sub`, and `mul` wrap on overflow; checked arithmetic is a Solidity-level feature.
- `writeInSlot.onlyWorkWith2256` intentionally overwrites a full packed slot to demonstrate the effect on co-located variables.
- `bytesToString.returnStringWrong` intentionally reverts: assigning a string literal in assembly sets the memory pointer, not the contents.

## License

MIT, see [`LICENSE`](LICENSE).
