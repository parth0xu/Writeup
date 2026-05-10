# flagchecker writeup

## Challenge files
- `bin/flagchecker`
- `bin/LICENSE`
- `bin/NOTICE`
- extra helper/reversing artifacts (`hook*.c`, `cmpok.c`, `ltrace.txt`, etc.)

## Quick recon
```bash
file bin/flagchecker
./bin/flagchecker
```
Output shows a stripped 64-bit ELF and usage:
```text
usage: flagcheck <flag>
```

`NOTICE` confirms MPL-2.0 for `flagchecker` and dynamic linking with GMP (LGPLv3+).

## What the binary does (high level)
The checker has two layers:
1. A custom coroutine/dispatch VM that mutates byte buffers between GMP steps.
2. A GMP arithmetic pipeline over imported bytes.

From tracing (`LD_PRELOAD` hooks on GMP calls), the constants are:
- `k1 = 9e3779b97f4a7c15f39cc0605cedc835`
- `k2 = 517cc1b727220a94fe13abe8fa9a6ee0`
- `k3 = c6bc279692b5cc83a0c83fbd5beecc4ad8c9aef72c87f3e16d7e4f5b9a3d8e2d`
- `k4 = be5466cf34e90c6cc0ac29b7c97c50dd`
- target `C = 8f97a0ff7131f61a27b9914c061494f198f160340bdc4642f0b8ddd2f5efbc90e8ebbafe6e3a8fd218`

Arithmetic core (for length `n` bytes):
- `M = 2^(8n)`
- `x2 = VM_A( ((x0 * k1) mod M) xor k2 )`
- `x5 = VM_B( ((x2 * k3) mod M + k4) mod M )`
- `x7 = rol(x5, 73, 8n)`
- check: `(x7 xor C) == (M-1)`

Here, `VM_A` and `VM_B` are the hidden per-byte VM transforms.

## Important observation
For fixed input length, `VM_A` and `VM_B` are deterministic byte-wise substitutions.
So we can recover each transform as a lookup table per byte position (0..n-1), then invert them.

The target length is `n=41` bytes (because the checker compares against an 82-hex-digit constant path in this solve).

## Solve method
1. Hook first `__gmpz_xor` result to force any chosen value, capture the next `__gmpz_import` bytes => this is `VM_A` output (`probeA`).
2. Hook first `__gmpz_add` result similarly, capture next import => `VM_B` output (`probeB`).
3. Build 256-entry tables for each byte position by feeding uniform bytes `00..ff`.
4. Invert equations from final check backward:
   - `x7 = (M-1) xor C`
   - `x5 = ror(x7,73)`
   - invert `VM_B`
   - invert `*k3 + k4 (mod M)`
   - invert `VM_A`
   - invert `*k1 xor k2 (mod M)`
5. Convert final integer to 41 bytes and test directly in `flagchecker`.

## Verified flag
```text
BtSCTF{ME_T#IHK_M3_U$ED_WRoNGG_L1CENSE11}
```

Verification:
```bash
./bin/flagchecker 'BtSCTF{ME_T#IHK_M3_U$ED_WRoNGG_L1CENSE11}'
```
returns:
```text
correct: BtSCTF{ME_T#IHK_M3_U$ED_WRoNGG_L1CENSE11}
```
