# Self-Review: Yul EVM Assembly

| | |
|---|---|
| Date | October 2026 |
| Commit reviewed | [`a6a7a77`](https://github.com/Usman-CrYpToo2/yul-evm-assembly/commit/a6a7a77) |
| Fixes | [`a079d70`](https://github.com/Usman-CrYpToo2/yul-evm-assembly/commit/a079d70) |
| Scope | All contracts under `src/` |
| Method | Manual review and a Foundry test suite written against the reviewed commit |

This is a self-review, not an independent audit.

## Summary

| Severity | Count | Fixed |
|---|---|---|
| High | 2 | 2 |
| Medium | 1 | 1 |
| Low | 3 | 3 |
| Informational | 1 | 1 |

Each fix is covered by a regression test.

## Findings

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
