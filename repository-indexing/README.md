# Repository Indexing

🇺🇸 English · 🇧🇷 [Português](README.pt-BR.md)

## Architectural Role

This utility creates a local metadata inventory of a repository. It is intentionally content-blind: it records file paths, types, sizes, and timestamps without reading file bodies or invoking external AI services.

## Contractual Obligations

- Accept a root path and output filename, defaulting to the current directory and `README_INDEX.md`.
- Use opt-in recursion in PowerShell through `-Recurse`; Bash recursion is controlled by `RECURSIVE=true` and defaults to enabled.
- Exclude the exact output path from the inventory.
- Sort entries deterministically and emit relative Markdown links, uppercase extension/type, byte size, and UTC-style modification time.
- Normalize path separators and handle spaces safely.
- Overwrite only the selected output file and report its path.

### Generated Results

The generated Markdown table has columns `File`, `Type`, `Size`, and `Last Modified`. It contains one row per selected file and no file contents. Existing `README_INDEX.md` or the configured output is replaced, preventing self-indexing.

### Safety and Recovery

Paths, names, sizes, and timestamps can expose repository structure. Review and protect the index before sharing. The utility does not alter source files, delete files, upload data, or call an AI service.

## Configuration

| Setting | PowerShell | Bash | Default |
| --- | --- | --- | --- |
| Root directory | `-RootPath` | `$1` | current directory |
| Output file (inside the root) | `-OutputFile` | `$2` | `README_INDEX.md` |
| Recurse into subdirectories | `-Recurse` | `RECURSIVE=true` / `false` | off (PowerShell), on (Bash) |

PowerShell parameters win; where a parameter's default reads an environment variable, that variable applies when the parameter is omitted. `$1`, `$2` and `$3` are Bash positional arguments; when both the environment variable and the argument are set, the variable wins.

## Usage

Prerequisites: PowerShell or Bash with read access to the tree and write access to the output path.

PowerShell recursive: `./index-repository.ps1 -RootPath C:\path\to\repository -Recurse`

Bash recursive: `RECURSIVE=true ./index-repository.sh /path/to/repository README_INDEX.md`

Treat generated metadata as potentially sensitive because paths and timestamps may reveal local information.

## Telemetry & Observability

Only the local output path is reported. The table itself is the diagnostic artifact; no external telemetry is collected.

## Verification

Test recursive and non-recursive modes, output self-exclusion, an empty directory, filenames with spaces, invalid roots, and repeated execution. Confirm every row links relative to the selected root and no contents are embedded.
