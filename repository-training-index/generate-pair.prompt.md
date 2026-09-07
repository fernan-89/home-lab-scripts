# Generate the Repository Training Index Pair From Scratch

Act as a senior cross-platform automation maintainer. Generate exactly `generate-training-index.ps1`, `generate-training-index.sh`, and a local `README.md`.

## Objective and Inputs

Create a local Markdown snapshot of repository file contents for offline onboarding or review. PowerShell must accept `-RootPath` and `-OutputFile`; Bash must accept root and output arguments. Defaults are the current directory and `base_treinamento.md`.

## Required Behavior

- Validate the root directory and output path before writing.
- Recursively enumerate files in deterministic sorted order.
- Exclude `.git`, `.idea`, `.gradle`, `build`, `bin`, and `obj` directories; exclude the output file and both generator scripts, including legacy `gerar_base.ps1` when present.
- Emit each entry as `## File: relative/path`, followed by an untyped triple-backtick block containing the complete file contents.
- Normalize relative paths to `/`, preserve source text as safely as the host encoding allows, and report only the output path.
- Overwrite only the explicitly configured output and never upload or transmit source contents.

## Safety and Parity

The generated snapshot may contain credentials, source code, infrastructure identifiers, and private paths. Warn the operator to inspect and redact it before sharing. Use caller parameters/arguments and never embed real identifiers. PowerShell and Bash must use equivalent exclusions, ordering, output structure, and local-only behavior; both must exclude their own generator script.

## Acceptance and Output

Parser-validate PowerShell and run `bash -n` where available. Test included files, excluded build/IDE/VCS files, output self-exclusion, nested paths, and content containing Markdown fences. The README must contain `Architectural Role`, `Contractual Obligations`, `Telemetry & Observability`, prerequisites, examples, and sensitive-output handling. Return the three complete files in separate Markdown code blocks. Do not modify the root `README.md` or `LICENSE`.