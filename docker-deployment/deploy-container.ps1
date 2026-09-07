param(
    [string]$RepositoryUrl = $env:GIT_REPOSITORY_URL,
    [string]$WorkingDirectory = (Join-Path $PWD "source"),
    [string]$ContainerName = $(if ($env:CONTAINER_NAME) { $env:CONTAINER_NAME } else { "home-lab-app" }),
    [string]$ImageName = $(if ($env:IMAGE_NAME) { $env:IMAGE_NAME } else { "home-lab-app:latest" }),
    [string]$MongoDbUri = $env:MONGODB_URI,
    [int]$HostPort = $(if ($env:HOST_PORT) { [int]$env:HOST_PORT } else { 8080 }),
    [int]$ContainerPort = $(if ($env:CONTAINER_PORT) { [int]$env:CONTAINER_PORT } else { 8080 })
)
$ErrorActionPreference = "Stop"
if ([string]::IsNullOrWhiteSpace($RepositoryUrl)) { throw "Set GIT_REPOSITORY_URL or provide -RepositoryUrl." }
if ([string]::IsNullOrWhiteSpace($MongoDbUri)) { throw "Set MONGODB_URI or provide -MongoDbUri." }
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) { throw "Docker is required." }
docker rm -f $ContainerName 2>$null
docker image rm $ImageName 2>$null
if (Test-Path $WorkingDirectory) { Remove-Item $WorkingDirectory -Recurse -Force }
git clone $RepositoryUrl $WorkingDirectory
Push-Location $WorkingDirectory
try {
    docker build -t $ImageName .
    docker run -d --name $ContainerName -p "${HostPort}:${ContainerPort}" -e "MONGODB_URI=$MongoDbUri" $ImageName
}
finally { Pop-Location }