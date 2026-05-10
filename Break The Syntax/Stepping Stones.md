# Stepping Stones

## Challenge Info
- Binary: `/media/sf_kali/chall`
- Type: 64-bit ELF, PIE, stripped, C++
- Flag format: `BtSCTF{...}`

## Initial Recon
I started with static triage:
- `file /media/sf_kali/chall`
- `checksec --file=/media/sf_kali/chall`
- `strings -n 5 /media/sf_kali/chall`
- `objdump -d /media/sf_kali/chall`

Key observations:
- Prompt string: `Enter product key:`
- Failure string: `Invalid product key. Access denied.`
- A set of 14 suspicious 32-byte-looking records in `.rodata`, several resembling fake/decoy keys.
- One obvious decoy string: `BtSCTF{TEST-TEST-TEST-TEST-2D3F}`

## Where Flow Gets Interrupted
The challenge hint was: “Something keeps interrupting your flow.”

The interruption is literal:
- A pre-check routine scans part of `.text` and counts bytes equal to `0xCC` (`int3`, breakpoint opcode).
- That count is added into the validator state.

Implication:
- If you set software breakpoints in a debugger, you inject extra `0xCC` bytes.
- The computed validator path/round alignment changes.
- You get persistent failure even when reasoning seems right.

This is why normal step-debugging appears to derail progress.

## Validation Structure
From disassembly around the main validator:
- Input length must be exactly 32 bytes.
- There is a table of 14 entries in `.rodata`.
- Each entry is:
  - `uint64 stride`
  - `32-byte pattern`
- The validator iterates rounds with a seeded progression and computes an index into the 14-entry table.
- Per round, it compares all 32 characters using index permutation:
  - compare input byte `i` against table byte at position `(i * stride) & 31`

Important quirk:
- Earlier rounds can be effectively decoy checks.
- The success condition lands on a specific final round state (which anti-debug influences).

## Solving Strategy
To avoid anti-debug side effects:
1. Parse `.rodata` entries directly from the file.
2. Reproduce candidate permutations in a local script.
3. Test generated candidates by piping them to the binary (no breakpoints injected).

A brute-force over the 14 table rows with both mapping directions quickly identifies the accepted key.

## Recovered Flag
`BtSCTF{5T3P-P1NG-STON-ES00-8D9F}`

## Minimal Repro Script
```python
from pathlib import Path
import struct, subprocess

p = Path('/media/sf_kali/chall').read_bytes()
ro = p[0x1660:0x1910]

entries = []
for i in range(14):
    off = 0x28 + i * 40
    stride = struct.unpack_from('<Q', ro, off)[0]
    pat = ro[off + 8: off + 40]
    entries.append((pat, stride))

def run(key: bytes):
    r = subprocess.run(['/media/sf_kali/chall'], input=key + b'\n', stdout=subprocess.PIPE)
    out = r.stdout.decode('latin1', errors='ignore')
    return ('License Valid' in out), out

for idx, (pat, stride) in enumerate(entries):
    # direction 1
    k1 = bytes(pat[(i * stride) & 31] for i in range(32))
    ok, out = run(k1)
    if ok:
        print('PASS row', idx, k1.decode())
        print(out)
        break

    # direction 2
    arr = [0] * 32
    for i in range(32):
        arr[(i * stride) & 31] = pat[i]
    k2 = bytes(arr)
    ok, out = run(k2)
    if ok:
        print('PASS row', idx, k2.decode())
        print(out)
        break
```

## Final Notes
- If debugging is required, prefer hardware breakpoints to avoid planting `0xCC`.
- For anti-debug-heavy binaries, file-based emulation of checker logic is often faster and more reliable than live stepping.
