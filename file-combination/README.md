# Text File Combination

Combines top-level `.txt` files into a configurable output file and excludes that output from the input set.

Prerequisites: PowerShell or Bash with read/write access to the directory.

PowerShell: `./combine-text-files.ps1 -InputDirectory C:\path\to\files -OutputFile combined.txt`

Bash: `./combine-text-files.sh /path/to/files combined.txt`

## Architectural Role

This utility creates one local text bundle from top-level `.txt` files. It is intended for review, transfer, or archival preparation and does not modify source files.

## Contractual Obligations

- Accept an input directory and output filename, defaulting to the current directory and `combined.txt`.
- Select only top-level `.txt` files and sort them deterministically.
- Exclude the output file by canonical path so it cannot include itself.
- Concatenate source contents in order using UTF-8 handling and overwrite only the configured output.
- Report the source-file count and output path.
- Fail clearly when the input directory or output destination is invalid.

### Generated Results

The output is one text file containing the contents of every selected source file. The scripts do not add hidden metadata or separators beyond the source content, and they do not recurse into child directories. Existing output is replaced deliberately.

PowerShell uses `-InputDirectory` and `-OutputFile`; Bash accepts the input directory and output arguments.

### Safety and Recovery

Review the source set before execution and back up an existing output if it matters. Source files are read but never deleted or changed. Combined content may contain credentials or private data; inspect it before sharing.

## Telemetry & Observability

Only local count and output-path messages are emitted. No network calls or external telemetry occur. The output can reproduce sensitive source text and should remain access-controlled.

## Verification

Test empty input, multiple files, nested files, filenames with spaces, an existing output, and an output name that would otherwise match an input. Confirm the output excludes itself and preserves source order.