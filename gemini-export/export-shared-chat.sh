#!/usr/bin/env bash
set -euo pipefail
SHARE_URL="${1:-}"
OUTPUT_FILE="${CHAT_OUTPUT_FILE:-shared-chat.md}"
[[ "$SHARE_URL" =~ ^https://([a-z0-9-]+\.)*gemini\.google\.com/ ]] || { echo "Provide an approved Gemini share URL." >&2; exit 1; }
if command -v xdg-open >/dev/null; then xdg-open "$SHARE_URL"; elif command -v open >/dev/null; then open "$SHARE_URL"; else echo "Open manually: $SHARE_URL"; fi
printf '# Shared chat export\n\nOpened for manual export: %s\n\nPaste approved content below this heading.\n' "$SHARE_URL" > "$OUTPUT_FILE"