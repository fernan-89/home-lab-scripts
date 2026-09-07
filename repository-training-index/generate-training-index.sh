#!/usr/bin/env bash
set -euo pipefail

ROOT_PATH="${1:-$PWD}"
OUTPUT_FILE="${2:-base_treinamento.md}"
ROOT_PATH="$(cd -- "$ROOT_PATH" && pwd)"
OUTPUT_PATH="$ROOT_PATH/$OUTPUT_FILE"

if [[ ! -d "$ROOT_PATH" ]]; then
    printf 'Root directory does not exist: %s\n' "$ROOT_PATH" >&2
    exit 1
fi

: > "$OUTPUT_PATH"
while IFS= read -r -d '' file; do
    relative="${file#"$ROOT_PATH"/}"
    {
        printf '## File: %s\n' "$relative"
        printf '```\n'
        cat -- "$file"
        printf '\n```\n\n'
    } >> "$OUTPUT_PATH"
done < <(
    find "$ROOT_PATH" -type f \
        ! -path "$OUTPUT_PATH" \
        ! -name 'gerar_base.ps1' \
        ! -name 'generate-training-index.ps1' \
        ! -name 'generate-training-index.sh' \
        ! -path '*/.git/*' \
        ! -path '*/.idea/*' \
        ! -path '*/.gradle/*' \
        ! -path '*/build/*' \
        ! -path '*/bin/*' \
        ! -path '*/obj/*' \
        -print0 | sort -z
)

printf 'Training index written to %s.\n' "$OUTPUT_PATH"
