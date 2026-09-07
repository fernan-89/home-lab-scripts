# Existing Repository Setup

Configures an existing local repository with GitHub Actions branches and publishes it through the authenticated GitHub CLI. Root documentation files are intentionally not generated until the final documentation command is authorized.

Prerequisites: Git, GitHub CLI (`gh`), an authenticated `gh` session, and network access to GitHub.

PowerShell: `./setup-existing-repository.ps1 -RepositoryPath C:\path\to\repository -GitIgnoreLanguage PowerShell -Visibility private`

Bash: `GITIGNORE_LANGUAGE=PowerShell REPOSITORY_VISIBILITY=private ./setup-existing-repository.sh /path/to/repository`