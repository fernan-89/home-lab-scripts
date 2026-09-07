# Shared Chat Export

## Architectural Role

This category supports a controlled manual export of an approved Gemini shared-chat page. It opens a caller-provided link and creates a local Markdown placeholder; it does not scrape authenticated pages or automate credential handling.

## Contractual Obligations

- Require an HTTPS shared-chat URL and validate the approved Gemini host.
- Open the URL with the native browser opener when available.
- Create or overwrite a local Markdown file with a title, source URL, manual-export status, and paste instruction.
- Never collect cookies, passwords, tokens, authenticated page data, or unrelated browser content.
- Use `-ShareUrl` and `-OutputFile` in PowerShell or a URL argument and `CHAT_OUTPUT_FILE` in Bash.

### Generated Results

The generated `shared-chat.md` is a placeholder for content the operator manually reviews and pastes. It is not an automated transcript and does not guarantee that the page was opened or exported successfully.

### Safety and Recovery

Confirm the URL belongs to an approved share before opening it. Redact credentials, personal data, private infrastructure, and confidential conversation content before saving or sharing the Markdown file. The output may overwrite an existing export, so back it up when required.

## Telemetry & Observability

Only local browser/opening and output-path status is reported. No external telemetry, scraping, or upload occurs. The shared URL and pasted chat content can be sensitive.

## Verification

Test an approved HTTPS URL, invalid schemes, unsupported hosts, unavailable browser openers, output paths with spaces, and manual review of the generated placeholder.

Prerequisites: a browser and an approved Gemini share URL. Credentials are never stored by these scripts.

PowerShell: `./export-shared-chat.ps1 -ShareUrl https://gemini.google.com/share/EXAMPLE`

Bash: `./export-shared-chat.sh https://gemini.google.com/share/EXAMPLE`