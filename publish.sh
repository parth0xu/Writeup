#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   GITHUB_TOKEN=ghp_xxx ./publish.sh

if [[ -z "${GITHUB_TOKEN:-}" ]]; then
  echo "Error: set GITHUB_TOKEN first (a GitHub Personal Access Token with repo scope)."
  exit 1
fi

USER="parth0xu"
REPO="parth0xu"
DESC="CTF and security writeups by parth0xu"

# Create profile repository if it does not exist
http_code=$(curl -sS -o /tmp/repo_create_resp.json -w "%{http_code}" \
  -X POST "https://api.github.com/user/repos" \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  -d "{\"name\":\"${REPO}\",\"description\":\"${DESC}\",\"private\":false}")

if [[ "$http_code" == "201" ]]; then
  echo "Created repository ${USER}/${REPO}"
elif [[ "$http_code" == "422" ]]; then
  echo "Repository ${USER}/${REPO} already exists"
else
  echo "Repository creation failed (HTTP ${http_code})"
  cat /tmp/repo_create_resp.json
  exit 1
fi

git remote remove origin 2>/dev/null || true
git remote add origin "https://github.com/${USER}/${REPO}.git"
git push -u "https://${USER}:${GITHUB_TOKEN}@github.com/${USER}/${REPO}.git" main

echo "Done: https://github.com/${USER}/${REPO}"
