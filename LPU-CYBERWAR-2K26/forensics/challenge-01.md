# DATA heist

## Metadata

- Category: `forensics`
- Source: `LPU-CYBERWAR-2K26/Writeups.txt` line 4
- Final Flag: `flag{1CMP_d4t4_5muggl1ng_1s_4_r34l_thr34t}`

## Challenge Summary

This writeup was reconstructed from your original notes and organized into a clean solve flow.

## Step-by-Step Solution

1. Open the PCAP
2. Filter only the ICMP packets
3. In the display filter bar (top), type icmp and press Enter.
4. Packet format: Choose “Packet details” (or “Packet bytes” if youwant the full hexdump).
5. Now copy all the payload and paste in decryptor and those big chunks “flag….” “flag…” are the keys . and After decrypting you will get the flag .
6. We find a sql injection in query parameter

## Commands / Evidence Snippets

```text
flag{1CMP_d4t4_5muggl1ng_1s_4_r34l_thr34t}
```

## Analyst Notes

- Keep only validated artifacts in final answer.
- Prefer reproducible steps so this can be reused for similar CTF challenges.

## Final Flag

`flag{1CMP_d4t4_5muggl1ng_1s_4_r34l_thr34t}`
