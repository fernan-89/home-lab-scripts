#!/usr/bin/env bash
set -euo pipefail
ROOT_PATH="${1:-$PWD}"
OUTPUT_FILE="${2:-README_INDEX.md}"
RECURSIVE="${RECURSIVE:-true}"
ROOT_PATH="$(cd "$ROOT_PATH" && pwd)"
OUTPUT_PATH="$ROOT_PATH/$OUTPUT_FILE"
{
    printf '# Repository Index\n\n| File | Type | Size | Last Modified |\n| --- | --- | ---: | --- |\n'
    if [[ "$RECURSIVE" == "true" ]]; then
        find "$ROOT_PATH" -type f -print0
    else
        find "$ROOT_PATH" -maxdepth 1 -type f -print0
    fi | while IFS= read -r -d '' file; do
        [[ "$file" == "$OUTPUT_PATH" ]] && continue
        relative="${file#"$ROOT_PATH"/}"
        extension="${relative##*.}"
        [[ "$relative" == *.* ]] || extension="FILE"
        size="$(stat -c '%s' "$file" 2>/dev/null || stat -f '%z' "$file")"
        modified="$(stat -c '%y' "$file" 2>/dev/null | cut -d. -f1 || stat -f '%Sm' -t '%Y-%m-%dT%H:%M:%SZ' "$file")"
        printf '| [%s](%s) | %s | %s | %s |\n' "$relative" "$relative" "${extension^^}" "$size" "$modified"
    done
} > "$OUTPUT_PATH"
printf 'Repository index written to %s.\n' "$OUTPUT_PATH"
