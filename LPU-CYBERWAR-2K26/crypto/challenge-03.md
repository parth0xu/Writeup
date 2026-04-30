# Challenge:

## Metadata

- Category: `crypto`
- Source: `LPU-CYBERWAR-2K26/Writeups.txt` line 1673
- Final Flag: `flag{y0u_f0und_meee_c0nGO_I_AM_pr0ud}`

## Challenge Summary

This writeup was reconstructed from your original notes and organized into a clean solve flow.

## Step-by-Step Solution

1. 5. Decrypt PrivateBin payload
2. - Decoded fragment after # as Base58 key material.
3. - Decrypted ciphertext using AES-256-GCM with proper AAD from adata.
4. 6. Decode final encoded string
5. - Decrypted chat log contained a long encoded blob.
6. - Blob decoded using Ascii85.
7. - Output revealed i2p info, password, and final flag.
8. Recovered Flag:
9. I just used a directory brute forcer with the help ho common dictionary and I got the folder for the flag . leak.txt. flag{c4ll_us3r_func_rc3_7d2e9f1a}

## Commands / Evidence Snippets

```text
- Pulled JSON API data from PrivateBin (encrypted ct + adata).
- Decrypted ciphertext using AES-256-GCM with proper AAD from adata.
FLAG{y0u_f0und_meee_c0nGO_I_AM_pr0ud}
I just used a directory brute forcer with the help ho common dictionary and I got the folder for the flag . leak.txt. flag{c4ll_us3r_func_rc3_7d2e9f1a}
"Runtime": "python3.12",
```

## Analyst Notes

- Keep only validated artifacts in final answer.
- Prefer reproducible steps so this can be reused for similar CTF challenges.

## Final Flag

`flag{y0u_f0und_meee_c0nGO_I_AM_pr0ud}`
