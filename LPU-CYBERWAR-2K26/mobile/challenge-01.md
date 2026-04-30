# - Since challenge hinted encrypted/hidden flag at right place, tested stego extraction.

## Metadata

- Category: `mobile`
- Source: `LPU-CYBERWAR-2K26/Writeups.txt` line 645
- Final Flag: `flag{c0ngrats_y0u_inst4lled_i2p_n0w_g0_touch_gr4ss}`

## Challenge Summary

This writeup was reconstructed from your original notes and organized into a clean solve flow.

## Step-by-Step Solution

1. 4. Inspect bulletin.jpg
2. - Since challenge hinted encrypted/hidden flag at right place, tested stego extraction.
3. 5. Extract embedded payload with steghide
4. - Command used:
5. steghide extract -sf bulletin.jpg -p 0p3r4t10n_sh4d0w
6. - Extracted file:
7. 6. Read extracted file
8. Final Flag:
9. decode it to the HEXADECIMAL TO TEXT :- flag{w0w_s0_OP_OMG}
10. objdump -d magicnumber

## Commands / Evidence Snippets

```text
- Downloaded bulletin.jpg from authenticated page.
FLAG{c0ngrats_y0u_inst4lled_i2p_n0w_g0_touch_gr4ss}
grep -rn "flag{" .
./a/m/flag.txt:1:flag{d33p_1nt0_th3_f0ld3rs}
decode it to the HEXADECIMAL TO TEXT :- flag{w0w_s0_OP_OMG}
objdump -d magicnumber
From strings:
```

## Analyst Notes

- Keep only validated artifacts in final answer.
- Prefer reproducible steps so this can be reused for similar CTF challenges.

## Final Flag

`flag{c0ngrats_y0u_inst4lled_i2p_n0w_g0_touch_gr4ss}`
