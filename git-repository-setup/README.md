# Existing Repository Setup

🇺🇸 English · 🇧🇷 [Português](README.pt-BR.md)

## Architectural Role

This category configures an existing repository for a GitHub workflow and can publish branches through the GitHub CLI. It is a high-impact repository administration tool, not a passive local formatter. Root documentation files are intentionally not generated until the final documentation command is authorized.

## Contractual Obligations

- Validate Git, `gh`, authentication, network access, repository state, and visibility before mutation.
- Generate the selected `.gitignore` template and two workflow files under `.github/workflows`.
- Configure the `developer`, `stage`, and `master` branch flow as documented.
- Commit workflow changes only when changes exist.
- Create the remote repository and push branches only after explicit authorization.
- Never force-push, replace an unrelated remote, print tokens, or modify the root repository README implicitly.

### Generated Results

The scripts may create or replace `.gitignore`, `promote-developer-to-stage.yml`, and `validate-pull-request.yml`, plus a commit such as `chore: configure repository workflows`. With publishing enabled they also create a GitHub repository and push `developer`, `stage`, and `master`.

Visibility must be `public`, `private`, or `internal`.

### Safety and Recovery

Review generated workflows, target owner/name, visibility, branches, and remote before approving publication. Back up or commit local work first. If a remote operation fails, inspect `git status`, `git branch -a`, and `gh repo view`; do not retry blindly or force-push.

## Configuration

| Setting | PowerShell | Bash | Default |
| --- | --- | --- | --- |
| Repository path | `-RepositoryPath` | `$1` | required in PowerShell; current directory in Bash |
| `.gitignore` template language | `-GitIgnoreLanguage` | `GITIGNORE_LANGUAGE` | `PowerShell` |
| GitHub repository name | `-RepositoryName` | `REPOSITORY_NAME` | folder name |
| Visibility | `-Visibility` | `REPOSITORY_VISIBILITY` | `private` |

PowerShell parameters win; where a parameter's default reads an environment variable, that variable applies when the parameter is omitted. `$1`, `$2` and `$3` are Bash positional arguments; when both the environment variable and the argument are set, the variable wins.

## Usage

Prerequisites: Git, GitHub CLI (`gh`), an authenticated `gh` session, and network access to GitHub.

PowerShell: `./setup-existing-repository.ps1 -RepositoryPath C:\path\to\repository -GitIgnoreLanguage PowerShell -Visibility private`

Bash: `GITIGNORE_LANGUAGE=PowerShell REPOSITORY_VISIBILITY=private ./setup-existing-repository.sh /path/to/repository`

## Telemetry & Observability

Local Git and `gh` command output records configuration and publication progress. No separate telemetry service is used. Repository names, URLs, workflow content, and branch state may be sensitive; redact them from shared logs.

## Verification

Test prerequisite failures without `gh`, invalid visibility, workflow generation in a temporary repository, an already configured remote, declined publication, and successful branch validation in an isolated test repository.
