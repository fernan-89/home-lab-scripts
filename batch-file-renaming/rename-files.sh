#!/usr/bin/env bash
set -euo pipefail

DIRECTORY="${1:-}"
FIRST_WORD="${2:-}"
SECOND_WORD="${3:-}"
APPLY="${APPLY_CHANGES:-false}"
[[ -d "$DIRECTORY" && -n "$FIRST_WORD" && -n "$SECOND_WORD" ]] || { echo "Usage: $0 DIRECTORY FIRST_WORD SECOND_WORD" >&2; exit 1; }
PREFIX="$(printf '%s-%s' "${FIRST_WORD:0:3}" "${SECOND_WORD:0:3}" | tr '[:lower:]' '[:upper:]')"
DATE_TAG="$(date +%Y%m%d)"
counter=1
declare -a CURRENT_NAMES NEW_NAMES
while IFS= read -r -d '' file; do
    current_name="${file##*/}"
    extension=".${current_name##*.}"
    [[ "$current_name" == *.* ]] || extension=""
    hash="$(LC_ALL=C tr -dc 'A-HJ-NP-Z0-9' < /dev/urandom | head -c 9 || true)"
    new_name="$(printf '%s-%03d-%s-%s%s' "$PREFIX" "$counter" "$hash" "$DATE_TAG" "$extension")"
    CURRENT_NAMES+=("$current_name")
    NEW_NAMES+=("$new_name")
    printf "Proposed: '%s' -> '%s'\n" "$current_name" "$new_name"
    ((counter += 1))
done < <(find "$DIRECTORY" -mindepth 1 -maxdepth 1 -type f -print0 | sort -z)
if ((${#CURRENT_NAMES[@]} == 0)); then echo "No files found."; exit 0; fi
if [[ "$APPLY" != "true" ]]; then echo "Dry run only. Set APPLY_CHANGES=true to rename files."; exit 0; fi
for index in "${!CURRENT_NAMES[@]}"; do
    mv -- "$DIRECTORY/${CURRENT_NAMES[$index]}" "$DIRECTORY/${NEW_NAMES[$index]}"
done