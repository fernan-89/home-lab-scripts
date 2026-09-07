# Repository Indexing

Creates a local Markdown inventory of files, types, sizes, and modification times. It does not upload content or call external AI services.

Prerequisites: PowerShell or Bash with read access to the tree and write access to the output path.

PowerShell recursive: `./index-repository.ps1 -RootPath C:\path\to\repository -Recurse`

Bash recursive: `RECURSIVE=true ./index-repository.sh /path/to/repository README_INDEX.md`

Treat generated metadata as potentially sensitive because paths and timestamps may reveal local information.
