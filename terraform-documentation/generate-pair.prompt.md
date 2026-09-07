# Generate the Terraform Documentation Pair From Scratch

Act as a senior infrastructure maintainer. Generate exactly `document-terraform.ps1`, `document-terraform.sh`, and a local `README.md`.

## Objective and Inputs

Aggregate Terraform source into a reviewable Markdown document without executing Terraform. PowerShell must require `-RootPath` and `-OutputPath`; Bash must require root and output positional arguments. The root must exist and the output must be writable.

## Required Behavior

- Recursively find `.tf` files, sort them deterministically, and fail clearly when none exist.
- Overwrite the configured output with one section per Terraform file containing its relative path, an `hcl` fenced code block with the complete source, and a `---` separator.
- Normalize relative paths to `/` and preserve UTF-8 source text.
- Do not run `terraform`, evaluate expressions, resolve modules, or modify source files.
- Report the output path and the number of source files included.
- Do not silently create an output parent directory unless that behavior is documented consistently in both scripts.

## Safety and Parity

Terraform source may contain credentials, infrastructure identifiers, endpoints, or sensitive variables. Never invent or embed real values; warn operators to redact and review the generated document before publication. Use caller paths only. PowerShell and Bash must provide equivalent discovery, ordering, formatting, and failure behavior. The README must contain `Architectural Role`, `Contractual Obligations`, `Telemetry & Observability`, prerequisites, examples, and sensitive-output guidance.

## Acceptance and Output

Parser-validate PowerShell and run `bash -n` where available. Test multiple `.tf` files, nested modules, no matching files, invalid roots, and source containing HCL fences. Return the three complete files in separate Markdown code blocks. Do not modify the root `README.md` or `LICENSE`.