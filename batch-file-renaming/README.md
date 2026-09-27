# Batch File Renaming

🇺🇸 English · 🇧🇷 [Português](README.pt-BR.md)

## Architectural Role

This utility applies a controlled naming policy to files in one directory. It is designed for repeatable local organization, with preview as the default and mutation explicitly enabled by the operator.

## Contractual Obligations

- Inspect top-level files in deterministic order.
- Build names in the form `ABC-DEF-001-RANDOMID-YYYYMMDD.extension`.
- Derive the three-character prefix from the two caller-provided words and preserve the original extension.
- Print every proposed source and destination name before any rename.
- Run as a dry run by default; require `-Apply` or `APPLY_CHANGES=true` to mutate.
- Refuse invalid directories, empty naming inputs, duplicate destinations, and existing destination collisions.

### Generated Results

The scripts do not create a report file. They generate a mapping in stdout and, in apply mode, rename files in place. The sequence and date portions are generated per run; the random identifier prevents accidental name reuse. No file content is changed.

### Safety and Recovery

Run the preview first and review every destination. Create a backup or commit before applying. A failed or interrupted rename may require manual recovery from the printed mapping; scripts must never overwrite an existing file.

## Configuration

| Setting | PowerShell | Bash | Default |
| --- | --- | --- | --- |
| Directory | `-Directory` | `$1` | required |
| First word (prefix) | `-FirstWord` | `$2` | required |
| Second word (prefix) | `-SecondWord` | `$3` | required |
| Apply the renames | `-Apply` | `APPLY_CHANGES=true` | off (dry run) |

PowerShell parameters win; where a parameter's default reads an environment variable, that variable applies when the parameter is omitted. `$1`, `$2` and `$3` are Bash positional arguments; when both the environment variable and the argument are set, the variable wins.

## Usage

Prerequisites: PowerShell or Bash with permission to rename files.

PowerShell dry run: `./rename-files.ps1 -Directory C:\path\to\files -FirstWord mobile -SecondWord wallpaper`

PowerShell apply: `./rename-files.ps1 -Directory C:\path\to\files -FirstWord mobile -SecondWord wallpaper -Apply`

Bash dry run: `./rename-files.sh /path/to/files mobile wallpaper`

Bash apply: `APPLY_CHANGES=true ./rename-files.sh /path/to/files mobile wallpaper`

## Telemetry & Observability

Output contains proposed mappings, applied mappings, and no-op messages only. No network calls or external telemetry occur. Filenames may disclose business information, so redirect output only to a controlled location.

## Verification

Test preview mode, apply mode in a temporary directory, empty input, spaces in filenames, invalid words, duplicate targets, and an existing target file. Confirm extensions remain unchanged and the final directory contains no unintended overwrite.
