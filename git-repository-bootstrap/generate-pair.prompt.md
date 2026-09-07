# Generate the Git Repository Bootstrap Pair From Scratch

Act as a senior DevOps maintainer. Generate exactly `bootstrap-repository.ps1`, `bootstrap-repository.sh`, and a local `README.md`.

## Objective and Inputs

Bootstrap a local Git repository and optionally configure its `origin`. PowerShell must accept `-RepositoryPath`, `-RemoteUrl`, and `-DefaultBranch`; Bash must accept repository path and remote URL arguments or `REPOSITORY_PATH`, `GIT_REMOTE_URL`, and `DEFAULT_BRANCH`. Defaults are `./repository` and `main`; the remote URL is required.

## Required Behavior

- Validate Git availability and create the target directory only when safe.
- Initialize Git if `.git` is absent, but preserve an existing repository and existing remotes.
- Add `origin` only when it does not already exist; never silently replace a configured remote.
- Create a minimal `README.md` only when it is absent.
- Stage all files and create the documented initial commit only when staged changes exist.
- Configure the requested default branch without force-pushing.
- Report each mutation and the final repository status.

## Safety and Parity

Use caller-provided paths, remote URLs, branches, and messages; never embed identities, tokens, private hosts, or credentials. Do not delete files, rewrite history, or publish to a remote unless an explicit separately documented option exists. The PowerShell and Bash scripts must preserve existing repositories and produce equivalent results. The README must contain `Architectural Role`, `Contractual Obligations`, `Telemetry & Observability`, prerequisites, idempotence notes, and review steps before remote operations.

## Acceptance and Output

Parser-validate PowerShell and run `bash -n` where available. Test an empty directory, an existing repository, an existing remote, a missing remote URL, and a second idempotent run in temporary repositories. Return the three complete files in separate Markdown code blocks. Do not modify the root `README.md` or `LICENSE`.