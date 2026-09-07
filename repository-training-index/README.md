# Repository Training Index

## Architectural Role

This category creates a local Markdown snapshot of source contents for offline onboarding, review, or training. Unlike `repository-indexing`, it intentionally includes file bodies and therefore requires stronger handling of generated output.

## Contractual Obligations

- Accept a repository root and output filename, defaulting to the current directory and `base_treinamento.md`.
- Recursively enumerate files in deterministic order.
- Exclude `.git`, `.idea`, `.gradle`, `build`, `bin`, and `obj`, plus the output and all generator scripts.
- Render each file as `## File: relative/path` followed by an untyped triple-backtick code block containing its contents.
- Keep all processing local and report only the output path.
- Overwrite only the explicitly selected output file.

### Generated Results

The result is `base_treinamento.md` or the configured Markdown path. It contains complete source snapshots for included files, including prompts, scripts, and documentation. It is not a compact index and may become large.

### Safety and Recovery

The snapshot may contain credentials, private paths, infrastructure identifiers, source code, and confidential documentation. Review and redact it before sharing, store it with restricted permissions, and delete or regenerate it when source content changes. Never treat the generated file as safe for publication by default.

## Telemetry & Observability

The scripts report only the local output path and perform no upload or external telemetry. Exclusion behavior is part of the safety contract and must be reviewed when adding new build or IDE directories.

## Verification

Confirm included files appear once, excluded directories do not appear, generator scripts and output self-exclude, nested paths normalize correctly, and content containing Markdown fences remains reviewable.

## Architectural Role

This category creates a local Markdown snapshot of source files for onboarding, review, or offline training. It is intentionally separate from the operational repository index because it includes file contents rather than metadata only.

## Contractual Obligations

- Accept a repository root and output filename from the caller.
- Exclude build caches, IDE state, version-control internals, generated output, and the generator scripts themselves.
- Sort files deterministically.
- Keep all processing local and never upload source contents.
- Treat the generated snapshot as potentially sensitive.
- Use the PowerShell and Bash implementations interchangeably for the same input contract.

PowerShell:

```powershell
./generate-training-index.ps1 -RootPath C:\path\to\repository -OutputFile base_treinamento.md
```

Bash:

```bash
./generate-training-index.sh /path/to/repository base_treinamento.md
```

## Telemetry & Observability

The scripts report only the output path. No external telemetry is collected and no source contents are transmitted outside the local machine.
