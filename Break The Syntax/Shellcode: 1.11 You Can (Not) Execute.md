 # Shellcode: 1.11 You Can (Not) Execute

## Challenge Info
- Binary: `a.out` (32-bit, dynamically linked)
- Loader: custom `ld-linux.so.2`
- Library: `libponi.so`
- Mitigations on `a.out`:
  - NX enabled
  - No PIE
  - No canary
  - Partial RELRO

Remote endpoint:
- `tcp-shellcode-23927bbcf875c685.chall.bts.wh.edu.pl:443` (TLS/SNI)

---

## Source Review
`a.c`:
```c
int main(void)
{
    char da_shellcode[8];
    write(1, da_shellcode, 64);
    read(0, da_shellcode, 28);
    return 0;
}
```

Two critical bugs:
1. **Stack leak**: `write(1, da_shellcode, 64)` leaks 64 bytes from the stack.
2. **Stack overflow**: `read(0, da_shellcode, 28)` writes 28 bytes into an 8-byte buffer.

Because NX is enabled, direct stack shellcode execution is blocked.

---

## Why Classic ret2libc Is Awkward Here
This challenge uses a tiny custom runtime (`libponi.so` + `ld-linux.so.2`) instead of full glibc in the usual way. A straightforward `system('/bin/sh')` path is not available.

So we pivot to **SROP** (Sigreturn Oriented Programming) with `int 0x80` gadgets from `ld-linux.so.2`.

---

## Exploit Plan

### 1. Leak addresses
From the initial 64-byte leak:
- recover a saved stack pointer context (to compute where our controlled buffer sits),
- recover a pointer inside `ld-linux.so.2` text to derive `ld_base`.

### 2. Stage-1 ROP (28-byte overflow budget)
Overwrite control data so execution returns into `read@plt` again, with args we control:
- `fd = 0`
- `buf = stack_buffer + 4`
- `count = 0x77`

Using `count = 0x77` is intentional: on i386, syscall number `0x77` is `sigreturn`.

### 3. Stage-2 payload
Send exactly `0x77` bytes so that when `read` returns, `eax = 0x77`.
Then return to gadget `int 0x80 ; ret` in `ld-linux.so.2`.
That triggers `sigreturn`, and the kernel restores registers from our fake frame.

We set frame registers for:
- `eax = 11` (`execve`)
- `ebx = ptr('/bin/sh')`
- `ecx = 0`
- `edx = 0`
- `eip = int 0x80 ; ret`

One subtle but important point: segment selectors must match this runtime:
- `cs = 0x23`
- `ss = ds = es = 0x2b`
- `fs = gs = 0`

Wrong selectors cause crashes.

### 4. Post-exploit command
After shell pops, send:
```bash
cat /app/flag.txt
```

---

## Final Flag
`BtSCTF{[poni-raws] The_End_of_Shellcode [BDRip 1920x1080 HEVC TrueHD].mkv}`

---

## Solver
Working solver script:
- `/home/parth/HACK/solve.py`

Run:
```bash
python3 /home/parth/HACK/solve.py
```

