# in detection u will see this :- Code insights

## Metadata

- Category: `mobile`
- Source: `LPU-CYBERWAR-2K26/Writeups.txt` line 787
- Final Flag: `flag{C:\dr0pp3d.bat}`

## Challenge Summary

This writeup was reconstructed from your original notes and organized into a clean solve flow.

## Step-by-Step Solution

1. The sample is a malicious dropper and environment-aware backdoor. It performs a connectivity check against 'quickheal.com' (sub_401000) and executes anti-VM/anti-sandbox checks by verifying CPU core count (>=8) and physical memory size (sub_4010c0). Upon successful environment validation, it decodes a Base64-encoded payload (sub_401140) containing batch commands to disable/modify firewall rules via 'netsh' (opening port 1337). The payload is dropped to 'C:\dr0pp3d.bat' (sub_4011d0) and persistence is established via the 'Run' registry key under the name 'Troubleshooting-Service' (sub_401230). Relevant IOCs include the file path 'C:\dr0pp3d.bat', the registry value 'Troubleshooting-Service', and the use of port 1337.

## Commands / Evidence Snippets

```text
flag{C:\dr0pp3d.bat}
Flag format: flag{}
└─$ grep -rn "flag{" .
./smali_classes3/com/ctf/armchairexplorer/MainActivity.smali:425: const-string v15, "flag{"
└─$ grep -rn "encrypted" .
```

## Analyst Notes

- Keep only validated artifacts in final answer.
- Prefer reproducible steps so this can be reused for similar CTF challenges.

## Final Flag

`flag{C:\dr0pp3d.bat}`
