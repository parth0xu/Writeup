# except Exception as e:

## Metadata

- Category: `crypto`
- Source: `LPU-CYBERWAR-2K26/Writeups.txt` line 951
- Final Flag: `flag{wh0_n33ds_pl4n3_t1ck3ts_wh3n_y0u_c4n_sp00f}`

## Challenge Summary

This writeup was reconstructed from your original notes and organized into a clean solve flow.

## Step-by-Step Solution

1. # 4. AES-GCM Decryption (NoPadding)
2. decrypted_text = cipher.decrypt_and_verify(ciphertext, tag)
3. return f"flag{{{decrypted_text.decode('utf-8')}}}"
4. return f"Decryption failed: {e}"
5. final flag :- flag{wh0_n33ds_pl4n3_t1ck3ts_wh3n_y0u_c4n_sp00f}
6. In `HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run`, a suspicious value was found:
7. 2. Extract staged payload from registry
8. 1. Base64 decode -> PowerShell stage

## Commands / Evidence Snippets

```text
return f"flag{{{decrypted_text.decode('utf-8')}}}"
final flag :- flag{wh0_n33ds_pl4n3_t1ck3ts_wh3n_y0u_c4n_sp00f}
i searched on google whole description and from that i got this :-
2. Extract staged payload from registry
```

## Analyst Notes

- Keep only validated artifacts in final answer.
- Prefer reproducible steps so this can be reused for similar CTF challenges.

## Final Flag

`flag{wh0_n33ds_pl4n3_t1ck3ts_wh3n_y0u_c4n_sp00f}`
