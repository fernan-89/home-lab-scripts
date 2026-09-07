#!/usr/bin/env bash
set -euo pipefail

JSON_DIRECTORY="${JSON_DIRECTORY:-${1:-}}"
ASSET_TAG_PREFIX="${ASSET_TAG_PREFIX:-ASSET-}"
COUNTER="${START_NUMBER:-1}"
[[ -n "$JSON_DIRECTORY" && -d "$JSON_DIRECTORY" ]] || { echo "Provide an existing JSON directory as the first argument or JSON_DIRECTORY." >&2; exit 1; }
command -v jq >/dev/null || { echo "jq is required." >&2; exit 1; }
mapfile -t JSON_FILES < <(find "$JSON_DIRECTORY" -maxdepth 1 -type f -name '*.json' -print | sort)
echo "Found ${#JSON_FILES[@]} JSON files."

for file in "${JSON_FILES[@]}"; do
    item_count="$(jq 'if type == "array" then length else 1 end' "$file")"
    last_tag=""
    for ((index = 0; index < item_count; index++)); do
        last_tag="${ASSET_TAG_PREFIX}$(printf '%03d' "$COUNTER")"
        if ((item_count == 1)); then
            jq --arg tag "$last_tag" '.assetTag = $tag' "$file" > "${file}.tmp"
        else
            jq --arg tag "$last_tag" --argjson index "$index" '.[ $index ].assetTag = $tag' "$file" > "${file}.tmp"
        fi
        mv -- "${file}.tmp" "$file"
        ((COUNTER += 1))
    done
    printf 'Updated %s; next number: %s\n' "$(basename "$file")" "$COUNTER"
done