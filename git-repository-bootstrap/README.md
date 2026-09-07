# Git Repository Bootstrap

## Architectural Role

This utility initializes a local Git repository and prepares its first commit while preserving existing repository state. It is a bootstrapper, not a publishing pipeline: remote configuration is explicit and history is never force-rewritten.

## Contractual Obligations

- Accept a repository path, required remote URL, and default branch.
- Create the directory when needed and initialize Git only when `.git` is absent.
- Preserve an existing repository, remote, files, and README.
- Add `origin` only when no origin exists; never replace a configured remote silently.
- Create a minimal README only when one is absent.
- Stage files and commit only when staged changes exist, using the documented initialization message.

### Generated Results

The scripts may create `.git`, `README.md`, Git configuration for `origin`, and an initial commit. They do not generate a report file, publish branches, force-push, or delete existing content. PowerShell accepts `-RepositoryPath`, `-RemoteUrl`, and `-DefaultBranch`; Bash accepts equivalent arguments or `REPOSITORY_PATH`, `GIT_REMOTE_URL`, and `DEFAULT_BRANCH`.

### Safety and Recovery

Inspect the target path and remote URL before execution. Use a disposable or version-controlled directory for first tests. Existing remotes and README files are protected; review `git status`, `git remote -v`, and the commit before any later publishing operation.

## Telemetry & Observability

Only local Git command status, repository path, and mutation summaries are emitted. No external telemetry or remote push is performed by the bootstrap operation itself. Remote URLs can disclose private infrastructure and should be redacted in shared logs.

## Verification

Test a new directory, an existing repository, an existing origin, a missing remote URL, a custom branch, and a second idempotent run. Confirm no unrelated files are deleted or rewritten.

Prerequisites: Git and an authenticated remote configured for the supplied URL.

PowerShell: `$env:GIT_REMOTE_URL='https://example.invalid/repository.git'; ./bootstrap-repository.ps1 -RepositoryPath ./repository`

Bash: `GIT_REMOTE_URL=https://example.invalid/repository.git ./bootstrap-repository.sh ./repository`