# Directory Indexing

## Architectural Role

This utility produces a navigable Markdown view of directory structure for local review and handoff. It records names and hierarchy only; it does not read file contents or contact external services.

## Contractual Obligations

- Accept a root path, output filename, and maximum depth.
- Default to the current directory, `README.md`, and unlimited depth.
- Enumerate directories below the root, normalize links to `/`, and sort them deterministically.
- Render `# Directory Index` followed by links in the form `- [relative/path](relative/path/)`.
- Write the document at `<root>/<output>` and overwrite that exact output intentionally.
- Fail clearly when the root is missing or the output cannot be written.

### Generated Results

The output is a Markdown directory index. It contains one link per discovered directory and no file contents, file sizes, or external URLs. PowerShell exposes `-RootPath`, `-OutputFile`, and `-MaxDepth`; Bash accepts the root and output arguments and uses `MAX_DEPTH=0` for unlimited depth.

### Safety and Recovery

Review the destination before overwriting an existing README. Directory names can disclose project structure, so treat the generated index as potentially sensitive. The utility does not mutate source directories.

## Telemetry & Observability

Only the output path is reported locally. No telemetry, network calls, or uploads occur. Failures identify the invalid root or output path without exposing file contents.

## Verification

Test unlimited and bounded depth, an empty tree, nested directories, names containing spaces or Markdown characters, an invalid root, and an unwritable output. Confirm links resolve relative to the selected root.

Prerequisites: PowerShell or Bash and write access to the target directory.

PowerShell: `./generate-directory-index.ps1 -RootPath ./data -MaxDepth 3`

Bash: `MAX_DEPTH=3 ./generate-directory-index.sh ./data README.md`