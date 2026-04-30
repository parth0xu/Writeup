# Flag:

## Metadata

- Category: `forensics`
- Source: `LPU-CYBERWAR-2K26/Writeups.txt` line 1016
- Final Flag: `flag{176.103.56.89}`

## Challenge Summary

This writeup was reconstructed from your original notes and organized into a clean solve flow.

## Step-by-Step Solution

1. The workstation’s persistent outbound traffic is caused by registry-based PowerShell persistence that executes staged shellcode from registry data. The decoded payload points to attacker C2 IP:

## Commands / Evidence Snippets

```text
`flag{176.103.56.89}`
```

## Analyst Notes

- Keep only validated artifacts in final answer.
- Prefer reproducible steps so this can be reused for similar CTF challenges.

## Final Flag

`flag{176.103.56.89}`
