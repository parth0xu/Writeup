# easy drive :-

## Metadata

- Category: `binary`
- Source: `LPU-CYBERWAR-2K26/Writeups.txt` line 655
- Final Flag: `flag{d33p_1nt0_th3_f0ld3rs}`

## Challenge Summary

This writeup was reconstructed from your original notes and organized into a clean solve flow.

## Step-by-Step Solution

1. 6. Read extracted file
2. Final Flag:
3. decode it to the HEXADECIMAL TO TEXT :- flag{w0w_s0_OP_OMG}
4. objdump -d magicnumber

## Commands / Evidence Snippets

```text
FLAG{c0ngrats_y0u_inst4lled_i2p_n0w_g0_touch_gr4ss}
grep -rn "flag{" .
./a/m/flag.txt:1:flag{d33p_1nt0_th3_f0ld3rs}
decode it to the HEXADECIMAL TO TEXT :- flag{w0w_s0_OP_OMG}
objdump -d magicnumber
From strings:
flag{th1s_1s_n0t_th3_r34l_fl4g}
```

## Analyst Notes

- Keep only validated artifacts in final answer.
- Prefer reproducible steps so this can be reused for similar CTF challenges.

## Final Flag

`flag{d33p_1nt0_th3_f0ld3rs}`
