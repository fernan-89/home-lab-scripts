# Docker Deployment

Prerequisites: Git, Docker, a repository URL, and `MONGODB_URI` supplied through the environment.

PowerShell: `./deploy-container.ps1 -RepositoryUrl $env:GIT_REPOSITORY_URL`

Bash: `GIT_REPOSITORY_URL=https://example.invalid/project.git MONGODB_URI='mongodb://user:password@example.invalid/db' ./deploy-container.sh`

Optional variables: `APP_DIRECTORY`, `CONTAINER_NAME`, `IMAGE_NAME`, `HOST_PORT`, and `CONTAINER_PORT`.