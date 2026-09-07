#!/usr/bin/env bash
set -euo pipefail
ROOT_PATH="${1:-$PWD}"
OUTPUT_FILE="${2:-README.md}"
MAX_DEPTH="${MAX_DEPTH:-0}"
ROOT_PATH="$(cd "$ROOT_PATH" && pwd)"
if [[ "$MAX_DEPTH" -gt 0 ]]; then
	FIND_ARGS=(-mindepth 1 -maxdepth "$MAX_DEPTH" -type d)
else
	FIND_ARGS=(-mindepth 1 -type d)
fi
{ printf '# Directory Index\n'; find "$ROOT_PATH" "${FIND_ARGS[@]}" -print | while read -r directory; do relative="${directory#"$ROOT_PATH"/}"; printf -- '- [%s](%s/)\n' "$relative" "$relative"; done; } > "$ROOT_PATH/$OUTPUT_FILE"