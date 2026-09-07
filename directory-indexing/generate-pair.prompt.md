# Generate the Directory Indexing Pair From Scratch

Act as a senior cross-platform automation maintainer. Generate exactly `generate-directory-index.ps1`, `generate-directory-index.sh`, and a local `README.md` from this specification.

## Objective and Inputs

Create a Markdown index of directories below a caller-selected root. PowerShell must accept `-RootPath`, `-OutputFile`, and `-MaxDepth`; Bash must accept a root and optional output argument and honor `MAX_DEPTH=0` for unlimited depth. Defaults are the current directory, `README.md`, and unlimited depth.

## Required Behavior

- Validate that the root exists and is a directory and that the output is writable.
- Enumerate directories only, never files, using the configured depth.
- Produce `# Directory Index` followed by Markdown links in the form `- [relative/path](relative/path/)`.
- Normalize separators to `/`, sort paths deterministically, and safely represent names containing Markdown characters.
- Write the output at `<root>/<output>` and report the resulting path.
- Replace an existing output file deliberately and document that behavior.

## Safety, Parity, and Documentation

Keep processing local. Use parameters/environment variables instead of personal paths, hosts, credentials, or identifiers. Avoid following unsafe external links or uploading directory metadata. PowerShell and Bash must expose equivalent depth, ordering, output, and failure behavior even when their native enumeration commands differ. The README must contain `Architectural Role`, `Contractual Obligations`, `Telemetry & Observability`, prerequisites, examples, and overwrite warnings.

## Acceptance and Output

Parser-validate PowerShell and run `bash -n` where available. Test unlimited depth, bounded depth, an empty tree, invalid root, and names containing spaces. Return the three complete files in separate Markdown code blocks. Do not modify the root `README.md` or `LICENSE`.