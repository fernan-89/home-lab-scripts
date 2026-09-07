param([Parameter(Mandatory)][uri]$ShareUrl, [string]$OutputFile = $(if ($env:CHAT_OUTPUT_FILE) { $env:CHAT_OUTPUT_FILE } else { "shared-chat.md" }))
$ErrorActionPreference = "Stop"
if ($ShareUrl.Host -notmatch "(^|\.)gemini\.google\.com$") { throw "Only an approved Gemini host is accepted." }
Start-Process $ShareUrl.AbsoluteUri
"# Shared chat export`n`nOpened for manual export: $($ShareUrl.AbsoluteUri)`n`nPaste approved content below this heading." | Set-Content $OutputFile