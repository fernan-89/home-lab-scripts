# Docker Deployment

## Architectural Role

This category is a local deployment orchestrator for a Dockerized application. It synchronizes source code, builds an image, removes the configured previous runtime, and starts a detached replacement container. It is intentionally not a general-purpose release platform.

## Contractual Obligations

- Require a repository URL and MongoDB connection value from parameters or environment variables.
- Use configurable working directory, image name, container name, host port, and container port.
- Validate Git and Docker before changing the working tree or runtime.
- Remove the configured container, image, and working directory, clone the repository, build the image, and run it detached with the configured port mapping and `MONGODB_URI`.
- Stop on errors and report lifecycle stages without printing secret values.

### Generated Results

No report file is generated. The scripts mutate the configured working directory, create a Docker image, remove any existing image/container with the selected names, and create a running container. The container receives the MongoDB URI as an environment variable and maps `HOST_PORT` to `CONTAINER_PORT`.

PowerShell accepts `-RepositoryUrl`, `-WorkingDirectory`, `-ContainerName`, `-ImageName`, `-MongoDbUri`, `-HostPort`, and `-ContainerPort`. Bash accepts the repository URL and working directory arguments or `GIT_REPOSITORY_URL`, `APP_DIRECTORY`, `CONTAINER_NAME`, `IMAGE_NAME`, `MONGODB_URI`, `HOST_PORT`, and `CONTAINER_PORT`.

### Safety and Recovery

This operation is destructive. Review the target directory, container name, image name, repository, and ports before execution. Use a versioned source directory, confirm the old container can be removed, and retain the previous image or deployment instructions for rollback. Never commit or print `MONGODB_URI`; rotate it if it was exposed.

## Telemetry & Observability

The scripts emit local Docker/Git lifecycle output and the final container start result. They do not collect external telemetry. Use `docker ps`, `docker logs`, and `docker inspect` after deployment; redact secrets from captured logs.

## Verification

Validate configuration with Docker unavailable, test an isolated repository, confirm the built image and port mapping, inspect container environment handling, and verify that failed builds do not produce a false success message.

Prerequisites: Git, Docker, a repository URL, and `MONGODB_URI` supplied through the environment.

PowerShell: `./deploy-container.ps1 -RepositoryUrl $env:GIT_REPOSITORY_URL`

Bash: `GIT_REPOSITORY_URL=https://example.invalid/project.git MONGODB_URI='mongodb://user:password@example.invalid/db' ./deploy-container.sh`

Optional variables: `APP_DIRECTORY`, `CONTAINER_NAME`, `IMAGE_NAME`, `HOST_PORT`, and `CONTAINER_PORT`.