# Generate the Batch File Renaming Pair From Scratch

Act as a senior cross-platform automation maintainer. Generate exactly `rename-files.ps1`, `rename-files.sh`, and a local `README.md` in this category.

## Objective and Inputs

Rename every top-level file in a caller-selected directory using the pattern `ABC-DEF-001-RANDOMID-YYYYMMDD.extension`. PowerShell must accept `-Directory`, `-FirstWord`, `-SecondWord`, and `-Apply`; Bash must accept directory, first word, and second word arguments and honor `APPLY_CHANGES=true`. The words are trimmed, lowercased, and represented by their first three characters in uppercase. Use a nine-character random identifier from letters and digits while avoiding ambiguous characters where the existing implementation does so.

## Required Behavior

- Enumerate files in deterministic sorted order and preserve each original extension.
- Print every proposed source-to-destination mapping.
- Default to preview-only; rename only with the explicit apply flag.
- Refuse collisions, duplicate destinations, invalid directories, and unsafe empty naming inputs before mutation.
- Report clearly when no files are present.
- Keep generated names stable for the date and sequence portion during one run.

## Safety, Parity, and Documentation

Use caller parameters or environment variables, never embedded paths, hosts, credentials, or personal identifiers. Do not overwrite an existing file. Make the apply operation visibly explicit and explain that a backup/version-control checkpoint is recommended. The two scripts must expose equivalent behavior and logs. The README must include `Architectural Role`, `Contractual Obligations`, `Telemetry & Observability`, prerequisites, dry-run examples, and collision warnings.

## Acceptance and Output

Parser-validate PowerShell and run `bash -n` when available. Test dry-run, apply, empty input, invalid input, and collision handling in a temporary directory. Return the three complete files in separate Markdown code blocks. Do not modify the root `README.md` or `LICENSE`.