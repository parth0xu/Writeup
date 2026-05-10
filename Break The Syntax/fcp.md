# Flag Context Protocol (FCP) — Writeup

## Challenge files
- `mcp-server` (static Go ELF)
- `capture.pcapng` (TLS traffic to `127.0.0.1:8443`)

Flag format: `BtSCTF{...}`

## TL;DR
The `get_flag` logic in the binary is decoy-heavy if attacked directly. The reliable solve is to decrypt the pcap TLS application data and recover the real MCP `tools/call` response for `get_flag`.

Final flag:

`BtSCTF{more_like_midcp_67}`

## Recon
`mcp-server` exposes MCP tools including:
- `get_server_status`
- `get_flag`

`get_server_status` hints TLS constraints (`TLS 1.2`, RSA cipher suite). Direct runtime patching / decoy-path derivation can produce wrong outputs.

## Correct path
### 1) Decrypt TLS
The capture uses TLS 1.2 RSA sessions. We recovered the actual master secret from TLS debug output and built an NSS-style keylog file (`CLIENT_RANDOM ...`) for all observed ClientHello randoms in the capture.

Example tshark usage after creating `/tmp/sslkeys.log`:

```bash
tshark -r /media/sf_kali/capture.pcapng \
  -o "tls.keylog_file:/tmp/sslkeys.log" \
  -Y "http && tcp.port==8443" \
  -T fields -e tcp.stream -e frame.number -e http.request.method -e http.request.uri -e http.response.code -e http.file_data
```

### 2) Decode HTTP payloads
`http.file_data` is hex. Decode to UTF-8 and search for `get_flag` and `BtSCTF{`.

Example extraction script:

```python
import csv,binascii,re
with open('/tmp/http_decrypted.tsv', newline='') as f:
    for r in csv.reader(f, delimiter='\t'):
        if len(r) < 6 or not r[5]:
            continue
        txt = binascii.unhexlify(r[5]).decode('utf-8','replace')
        if 'get_flag' in txt or 'BtSCTF{' in txt:
            print(r[1], txt)
```

### 3) Locate the real response
In decrypted stream 5:
- Request frame `228`: `tools/call` with `"name":"get_flag"`
- Response frame `230`: JSON-RPC result containing:

```json
{"type":"text","text":"BtSCTF{more_like_midcp_67}"}
```

## Notes
- The earlier value `BtSCTF{78720838}` is a decoy/wrong path artifact.
- The pcap-derived MCP response is the authoritative source for the accepted flag.

## Flag
`BtSCTF{more_like_midcp_67}`
