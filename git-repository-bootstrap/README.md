# Git Repository Bootstrap

Prerequisites: Git and an authenticated remote configured for the supplied URL.

PowerShell: `$env:GIT_REMOTE_URL='https://example.invalid/repository.git'; ./bootstrap-repository.ps1 -RepositoryPath ./repository`

Bash: `GIT_REMOTE_URL=https://example.invalid/repository.git ./bootstrap-repository.sh ./repository`