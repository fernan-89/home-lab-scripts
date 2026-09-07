param([string]$RepositoryPath = (Join-Path $PWD "repository"), [string]$RemoteUrl = $env:GIT_REMOTE_URL, [string]$DefaultBranch = "main")
$ErrorActionPreference = "Stop"
if ([string]::IsNullOrWhiteSpace($RemoteUrl)) { throw "Set GIT_REMOTE_URL or provide -RemoteUrl." }
New-Item -ItemType Directory -Path $RepositoryPath -Force | Out-Null
Push-Location $RepositoryPath
try {
    if (-not (Test-Path .git)) { git init -b $DefaultBranch }
    if (-not (git remote)) { git remote add origin $RemoteUrl }
    if (-not (Test-Path README.md)) { "# Repository`n" | Set-Content README.md }
    git add .
    git diff --cached --quiet
    if ($LASTEXITCODE -ne 0) { git commit -m "chore: initialize repository" }
}
finally { Pop-Location }