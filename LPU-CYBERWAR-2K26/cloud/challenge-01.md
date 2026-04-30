# Loggy

## Metadata

- Category: `cloud`
- Source: `LPU-CYBERWAR-2K26/Writeups.txt` line 69
- Final Flag: `flag{devlopement-keys.pem_dev-neo}`

## Challenge Summary

This writeup was reconstructed from your original notes and organized into a clean solve flow.

## Step-by-Step Solution

1. ciphertext = base64.b64decode("0twztnSUTZA6vaFHQwgJjSNymcnnMQctv40qp7mMkCoOvtiJPqLR45rWRVPnkIWoATOprxd5dnY=")
2. plaintext = cipher.decrypt(ciphertext)
3. Extract the zip
4. Expand-Archive -LiteralPath .\S3.zip -DestinationPath .\S3_extracted -Force
5. Pehle sirf object download events filter karo (REST.GET.OBJECT).
6. rg -n "REST.GET.OBJECT" .\S3_extracted\S3-Server-Logs
7. ... arn:aws:iam::764581110688:user/dev-neo ... REST.GET.OBJECT delevopers-ec2.pem ... 200 ...
8. ... arn:aws:iam::764581110688:user/dev-neo ... REST.GET.OBJECT devlopement-keys.pem ... 200 ...
9. REST.GET.OBJECT = Download
10. rg -n "3\.144\.171\.70|dev-neo|REST.GET.BUCKET|REST.GET.OBJECT" .\S3_extracted\S3-Server-Logs
11. Agar future me similar CTF aaye, same 3 filters yaad rakhna: REST.GET.OBJECT + 200 + suspicious requester/IP correlation.
12. Identify suspicious ARP behavior I inspected ARP replies (arp.opcode == 2) and found repeated unsolicited claims from:

## Commands / Evidence Snippets

```text
flag{DES_cant_keep_secrets_when_the_key_is_weak!}
flag{devlopement-keys.pem_dev-neo}
Expand-Archive -LiteralPath .\S3.zip -DestinationPath .\S3_extracted -Force
rg -n "REST.GET.OBJECT" .\S3_extracted\S3-Server-Logs
rg -n "3\.144\.171\.70|dev-neo|REST.GET.BUCKET|REST.GET.OBJECT" .\S3_extracted\S3-Server-Logs
```

## Analyst Notes

- Keep only validated artifacts in final answer.
- Prefer reproducible steps so this can be reused for similar CTF challenges.

## Final Flag

`flag{devlopement-keys.pem_dev-neo}`
