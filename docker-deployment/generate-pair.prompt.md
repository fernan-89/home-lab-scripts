# Generate the Docker Deployment Pair From Scratch

Act as a senior DevOps maintainer. Generate exactly `deploy-container.ps1`, `deploy-container.sh`, and a local `README.md`.

## Objective and Inputs

Clone a caller-selected Git repository, build its Docker image, and run a detached container. PowerShell must support `-RepositoryUrl`, `-WorkingDirectory`, `-ContainerName`, `-ImageName`, `-MongoDbUri`, `-HostPort`, and `-ContainerPort`. Bash must accept the repository URL and working directory as positional values or use `GIT_REPOSITORY_URL`, `APP_DIRECTORY`, `CONTAINER_NAME`, `IMAGE_NAME`, `MONGODB_URI`, `HOST_PORT`, and `CONTAINER_PORT`. Defaults are `./source`, `home-lab-app`, `home-lab-app:latest`, and port `8080`.

## Required Behavior

- Validate Git, Docker, repository URL, and required `MONGODB_URI` before destructive actions.
- Remove the configured existing container and image, remove the configured working directory, clone the repository, build the image, and run it detached with the configured port mapping and MongoDB environment variable.
- Quote all values and preserve the caller's exact configuration.
- Report meaningful lifecycle stages without printing secret values.
- Fail immediately on errors and do not claim success after a failed Docker operation.

## Safety and Authorization

This workflow is destructive: it removes a container, image, and working directory. Require an explicit confirmation or documented apply switch before deletion, and explain the impact in README.md. Never embed repository URLs, private hosts, credentials, tokens, or connection strings. Do not pass secrets through logs, generated files, or command output. Prefer `--restart unless-stopped` only when it is an explicit documented option.

## Acceptance and Output

Parser-validate PowerShell and run `bash -n` where available. Test configuration validation with Docker unavailable and verify secrets do not appear in logs. The README must contain `Architectural Role`, `Contractual Obligations`, `Telemetry & Observability`, prerequisites, a dry-run/authorization workflow, and rollback guidance. Return the three complete files in separate Markdown code blocks and do not modify the root `README.md` or `LICENSE`.