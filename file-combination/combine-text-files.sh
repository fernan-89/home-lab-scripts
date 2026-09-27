#!/usr/bin/env bash
set -euo pipefail

INPUT_DIRECTORY="${1:-$PWD}"
OUTPUT_FILE="${2:-combined.txt}"
OUTPUT_PATH="$INPUT_DIRECTORY/$OUTPUT_FILE"
[[ -d "$INPUT_DIRECTORY" ]] || { echo "Input directory does not exist: $INPUT_DIRECTORY" >&2; exit 1; }
mapfile -t TEXT_FILES < <(find "$INPUT_DIRECTORY" -maxdepth 1 -type f -name '*.txt' ! -path "$OUTPUT_PATH" -print | sort)
: > "$OUTPUT_PATH"
for file in "${TEXT_FILES[@]}"; do cat "$file" >> "$OUTPUT_PATH"; done
printf 'Combined %s text files into %s.\n' "${#TEXT_FILES[@]}" "$OUTPUT_PATH"