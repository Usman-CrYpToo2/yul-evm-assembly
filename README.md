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

## Security

A self-review of this codebase found 7 issues (2 high, 1 medium, 3 low, 1 informational), all fixed and covered by regression tests. See [`audits/2026-10-self-review.md`](audits/2026-10-self-review.md).

## Notes

- Assembly `add`, `sub`, and `mul` wrap on overflow; checked arithmetic is a Solidity-level feature.
- `writeInSlot.onlyWorkWith2256` intentionally overwrites a full packed slot to demonstrate the effect on co-located variables.
- `bytesToString.returnStringWrong` intentionally reverts: assigning a string literal in assembly sets the memory pointer, not the contents.

## License

MIT, see [`LICENSE`](LICENSE).
