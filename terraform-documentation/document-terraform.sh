#!/usr/bin/env bash
set -euo pipefail
ROOT_PATH="${1:-}"
OUTPUT_PATH="${2:-}"
[[ -d "$ROOT_PATH" && -n "$OUTPUT_PATH" ]] || { echo "Usage: $0 ROOT_PATH OUTPUT_PATH" >&2; exit 1; }
mapfile -t TF_FILES < <(find "$ROOT_PATH" -type f -name '*.tf' -print | sort)
((${#TF_FILES[@]} > 0)) || { echo "No Terraform files were found." >&2; exit 1; }
: > "$OUTPUT_PATH"
for file in "${TF_FILES[@]}"; do
    {
        printf '## File: %s\n\n```hcl\n' "$file"
        cat "$file"
        printf '\n```\n\n---\n'
    } >> "$OUTPUT_PATH"
done
printf 'Documented %s Terraform files in %s.\n' "${#TF_FILES[@]}" "$OUTPUT_PATH"