# Git Security Hardening

## Architectural Role

This utility applies a repository-local ignore policy and removes selected local artifacts from Git tracking without deleting them from disk. It is a security hygiene operation with a broad staging and commit side effect.

## Contractual Obligations

- Validate that the target is a Git repository with a usable identity.
- Write rules covering build output, compiled files, archives, IDE state, logs, temporary files, OS metadata, Postman reports, and environment secrets.
- Untrack configured paths such as `build/`, `.gradle/`, `.idea/`, `bin/`, `out/`, and `*.iml` with `git rm --cached`.
- Preserve the ignored files in the working tree.
- Show the resulting `.gitignore`, staged diff, and final status.
- Require explicit review before broad staging and the security commit.

### Generated Results

The primary generated artifact is `.gitignore`. The index is changed for selected tracked paths, and the script may create a commit such as `security: apply gitignore and untrack local artifacts`. Files are not deleted from disk, and no remote push is performed.

PowerShell uses `-RepositoryPath`; Bash accepts the repository path as its first argument. Both default to the current directory.

### Safety and Recovery

Inspect `.gitignore`, `git diff --cached`, and `git status` before committing. A broad rule can hide files unexpectedly; refine it before approval. To recover, restore the previous `.gitignore` from version control and use `git add` to track an intentionally unignored file. This script does not remove secrets from Git history; historical exposure requires separate remediation.

## Telemetry & Observability

Only local Git status, staged paths, and commit output are emitted. No external telemetry occurs. Paths and staged filenames may reveal private project structure.

## Verification

Test tracked and untracked build artifacts, existing ignore rules, a missing Git identity, a declined confirmation, and a clean repository. Confirm ignored files remain on disk and no remote changes occur.

Creates a repository `.gitignore`, removes matching build/cache/IDE paths from the Git index, stages the changes, and commits them.

## Prerequisites

- Git installed and available on `PATH`.
- A target directory that is already a Git repository.
- Permission to modify the working tree and create commits.
- Git user identity configured with `git config user.name` and `git config user.email`.

## PowerShell

Run from any location and provide the repository root:

```powershell
.\configure-git-security.ps1 -RepositoryPath "C:\path\to\repository"
```

Or run it from the repository root:

```powershell
.\configure-git-security.ps1
```

## Bash

Make the script executable once, then provide the repository root as the first argument:

```bash
chmod +x ./configure-git-security.sh
./configure-git-security.sh /path/to/repository
```

Or run it from the repository root:

```bash
./configure-git-security.sh
```

## Notes

- Both versions commit changes automatically.
- Review `git status` and the generated `.gitignore` before running this script in a shared repository.
- The script does not remove ignored files from disk; it only removes matching paths from the Git index.