# Generate the Shared Chat Export Pair From Scratch

Act as a senior cross-platform automation maintainer. Generate exactly `export-shared-chat.ps1`, `export-shared-chat.sh`, and a local `README.md`.

## Objective and Inputs

Support a safe manual export workflow for an approved Gemini shared-chat URL. PowerShell must require `-ShareUrl` and accept `-OutputFile`; Bash must accept the URL as its first argument and use `CHAT_OUTPUT_FILE` for the output override. Default output is `shared-chat.md`.

## Required Behavior

- Accept only HTTPS URLs whose host is exactly an approved Gemini sharing host such as `gemini.google.com`; reject credentials, unsupported schemes, and malformed URLs.
- Open the URL using the native browser opener when available (`Start-Process`, `xdg-open`, or `open`).
- Never scrape authenticated pages, automate login, collect cookies, or store credentials.
- Create or overwrite a local Markdown placeholder containing a title, the opened URL, a manual-export note, and a clear instruction to paste reviewed content.
- Print the output path and make browser limitations explicit.
- Keep all unrelated data local and never transmit it.

## Safety, Parity, and Documentation

Use caller input only; do not embed a real account, token, private URL, hostname, or personal identifier. Treat pasted chat content as potentially sensitive and warn the operator to redact it. PowerShell and Bash must apply equivalent URL validation, output format, and failure behavior. The README must contain `Architectural Role`, `Contractual Obligations`, `Telemetry & Observability`, prerequisites, manual steps, and privacy warnings.

## Acceptance and Output

Parser-validate PowerShell and run `bash -n` where available. Test an approved URL, an invalid scheme, an unsupported host, and an output path with spaces. Return the three complete files in separate Markdown code blocks. Do not modify the root `README.md` or `LICENSE`.