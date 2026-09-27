#!/usr/bin/env bash
set -euo pipefail
REPOSITORY_PATH="${REPOSITORY_PATH:-${1:-$PWD/repository}}"
REMOTE_URL="${GIT_REMOTE_URL:-${2:-}}"
DEFAULT_BRANCH="${DEFAULT_BRANCH:-main}"
[[ -n "$REMOTE_URL" ]] || { echo "Set GIT_REMOTE_URL or pass a remote URL." >&2; exit 1; }
mkdir -p "$REPOSITORY_PATH"
cd "$REPOSITORY_PATH"
[[ -d .git ]] || git init -b "$DEFAULT_BRANCH"
git remote get-url origin >/dev/null 2>&1 || git remote add origin "$REMOTE_URL"
[[ -f README.md ]] || printf '# Repository\n' > README.md
git add .
git diff --cached --quiet || git commit -m "chore: initialize repository"