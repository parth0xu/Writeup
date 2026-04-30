# [*] Switching to interactive mode

## Metadata

- Category: `pwn`
- Source: `LPU-CYBERWAR-2K26/Writeups.txt` line 1293
- Final Flag: `flag{updat3d_n0t3s_uaf_tc4ch3_fr33h00k_a91c5d3e}`

## Challenge Summary

This writeup was reconstructed from your original notes and organized into a clean solve flow.

## Step-by-Step Solution

1. 3. Follow TCP stream (tcp.stream == 4) and inspect payload:
2. Extract server payload for stream 4
3. (example workflow used during solve)

## Commands / Evidence Snippets

```text
''' python exploit.py
└─$ python3 /home/parth/exploit.py REMOTE=1
flag{updat3d_n0t3s_uaf_tc4ch3_fr33h00k_a91c5d3e}
tshark -r SuspTeaEl.pcap -Y http.request \
tshark -r SuspTeaEl.pcap -q -z follow,tcp,hex,4
flag{why_1s_my_c3rt Security
```

## Analyst Notes

- Keep only validated artifacts in final answer.
- Prefer reproducible steps so this can be reused for similar CTF challenges.

## Final Flag

`flag{updat3d_n0t3s_uaf_tc4ch3_fr33h00k_a91c5d3e}`
