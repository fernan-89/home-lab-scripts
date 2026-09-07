# Generate the Existing Repository Setup Pair From Scratch

Act as a senior DevOps maintainer. Generate exactly `setup-existing-repository.ps1`, `setup-existing-repository.sh`, and a local `README.md`.

## Objective and Inputs

Configure an existing local repository with GitHub workflow files and publish selected branches. PowerShell must require `-RepositoryPath` and support the existing options for Gitignore language, repository name, and visibility. Bash must accept the repository path and use equivalent environment variables. Defaults are Gitignore language `PowerShell`, repository name from the directory, and visibility `private`; visibility must be `public`, `private`, or `internal`.

## Required Behavior

- Validate Git, GitHub CLI (`gh`), authentication, network access, and repository state before mutations.
- Initialize the `developer` branch when needed and preserve unrelated files.
- Download the selected GitHub `.gitignore` template without embedding an account or token.
- Generate `promote-developer-to-stage.yml` and `validate-pull-request.yml` under `.github/workflows`.
- Commit changes with `chore: configure repository workflows` only when changes exist.
- Create the GitHub repository with `gh repo create` and push `developer`, `stage`, and `master` only after explicit authorization.
- Report commands and branch operations without logging tokens.

## Safety and Parity

Remote repository creation and pushes are high-impact operations. Require a clearly documented confirmation/apply control, show the target owner/name/visibility, and never force-push or overwrite an existing remote without an explicit option. Use parameters/environment variables for all paths, accounts, URLs, and credentials. PowerShell and Bash must produce equivalent files and branch behavior. The README must contain `Architectural Role`, `Contractual Obligations`, `Telemetry & Observability`, prerequisites, dry-run/review guidance, and rollback notes.

## Acceptance and Output

Parser-validate PowerShell and run `bash -n` where available. Test validation failures without invoking `gh`, workflow generation in a temporary repository, an invalid visibility, and an unauthorized publish path. Return the three complete files in separate Markdown code blocks. Do not modify the root `README.md` or `LICENSE`.