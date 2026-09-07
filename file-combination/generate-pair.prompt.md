# Generate the File Combination Pair From Scratch

Act as a senior cross-platform automation maintainer. Generate exactly `combine-text-files.ps1`, `combine-text-files.sh`, and a local `README.md`.

## Objective and Inputs

Combine top-level `.txt` files from an input directory into one output file. PowerShell must accept `-InputDirectory` and `-OutputFile`; Bash must accept the directory and output arguments. Defaults are the current directory and `combined.txt`.

## Required Behavior

- Validate the input directory and output path before writing.
- Select only top-level `.txt` files and sort them by filename using a deterministic, case-aware rule documented in README.md.
- Exclude the output file by canonical path so the output cannot include itself.
- Overwrite the output deliberately, preserve UTF-8 text, and concatenate contents in order without inventing hidden metadata.
- Report the number of source files and final output path.
- Fail clearly on unreadable inputs or unwritable output.

## Safety and Parity

Keep all processing local and use parameters/arguments rather than embedded paths, hosts, credentials, or identifiers. Do not delete source files. PowerShell and Bash must produce equivalent ordering, filtering, encoding, overwrite, and error behavior. Explain that a backup is appropriate when the output already exists.

## Acceptance and Output

Parser-validate PowerShell and run `bash -n` where available. Test empty input, multiple files, an existing output, a nested file, and an output name matching an input. The README must contain `Architectural Role`, `Contractual Obligations`, `Telemetry & Observability`, prerequisites, examples, and overwrite behavior. Return the three complete files in separate Markdown code blocks. Do not modify the root `README.md` or `LICENSE`.