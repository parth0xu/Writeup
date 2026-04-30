# Grap the fist

## Metadata

- Category: `forensics`
- Source: `LPU-CYBERWAR-2K26/Writeups.txt` line 123
- Final Flag: `flag{192.168.10.30-00:0c:29:aa:bb:cc-C0rp0r@teP@ss!}`

## Challenge Summary

This writeup was reconstructed from your original notes and organized into a clean solve flow.

## Step-by-Step Solution

1. 3) Recover intercepted sensitive data
2. I then inspected HTTP traffic and found a login POST request:
3. POST /login.php
4. Decoded payload:
5. MemoryDumpInj Writeup
6. Uses DES ECB with key shown as masked: "E1".decode("hex")
7. At this point, brute forcing the DES key is not intended. The challenge name suggests memory forensics (MemoryDumpInj), so we pivot to the raw memory image.
8. Used Volatility 3 against MemoryDumpH.raw.
9. /tmp/vol3env/bin/vol -q -f /media/sfkali/MemoryDumpH.raw windows.info
10. Enumerated processes and command lines:
11. /tmp/vol3env/bin/vol -q -f /media/sfkali/MemoryDumpH.raw windows.pslist
12. /tmp/vol3env/bin/vol -q -f /media/sfkali/MemoryDumpH.raw windows.cmdline

## Commands / Evidence Snippets

```text
POST /login.php
Content-Type: application/x-www-form-urlencoded
To combine all of this we have = flag{192.168.10.30-00:0c:29:aa:bb:cc-C0rp0r@teP@ss!}
Imports flag from FLAG.py
python3 -m venv /tmp/vol3env
/tmp/vol3env/bin/vol -q -f /media/sfkali/MemoryDumpH.raw windows.info
/tmp/vol3env/bin/vol -q -f /media/sfkali/MemoryDumpH.raw windows.pslist
/tmp/vol3env/bin/vol -q -f /media/sfkali/MemoryDumpH.raw windows.cmdline
```

## Analyst Notes

- Keep only validated artifacts in final answer.
- Prefer reproducible steps so this can be reused for similar CTF challenges.

## Final Flag

`flag{192.168.10.30-00:0c:29:aa:bb:cc-C0rp0r@teP@ss!}`
