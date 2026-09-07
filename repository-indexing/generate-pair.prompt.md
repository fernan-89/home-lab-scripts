# Generate the Repository Indexing Pair From Scratch

Act as a senior cross-platform automation maintainer. Generate exactly `index-repository.ps1`, `index-repository.sh`, and a local `README.md`.

## Objective and Inputs

Create a local Markdown inventory of files without reading or uploading file contents. PowerShell must accept `-RootPath`, `-Recurse`, and `-OutputFile`; Bash must accept root and output arguments and use `RECURSIVE=true` by default. Defaults are the current directory and `README_INDEX.md`.

## Required Behavior

- Validate the root and output parent before writing.
- Enumerate files recursively only when enabled, otherwise inspect the root level.
- Exclude the exact output path so a second run cannot index its own report.
- Sort entries deterministically and emit a Markdown table with relative link, uppercase extension/type, byte size, and UTC-style last-modified time.
- Normalize relative separators to `/` and handle spaces safely.
- Report the final output path and fail clearly on inaccessible paths.

## Safety, Parity, and Documentation

This utility is metadata-only: do not read file contents, invoke external AI, upload data, or embed personal paths, hosts, credentials, or identifiers. Paths, names, sizes, and timestamps may still be sensitive. PowerShell and Bash must expose equivalent recursion, exclusion, ordering, and report semantics. The README must contain `Architectural Role`, `Contractual Obligations`, `Telemetry & Observability`, prerequisites, examples, and sensitivity guidance.

## Acceptance and Output

Parser-validate PowerShell and run `bash -n` where available. Test recursive and non-recursive modes, output exclusion, empty trees, inaccessible roots, and filenames containing spaces. Return the three complete files in separate Markdown code blocks. Do not modify the root `README.md` or `LICENSE`.