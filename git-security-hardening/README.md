# Git Security Hardening

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