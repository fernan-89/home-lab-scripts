param(
    [string]$RepositoryPath = (Get-Location).Path
)

$ErrorActionPreference = "Stop"

$repositoryPath = (Resolve-Path -Path $RepositoryPath).Path
Push-Location $repositoryPath
try {
    Write-Host "Starting Git security hardening..." -ForegroundColor Cyan

    if (-not (Test-Path -Path ".git")) {
        throw "The target directory is not a Git repository. Run 'git init' first or provide the repository root with -RepositoryPath."
    }

    $gitignoreContent = @'
# Java and compiled artifacts
*.class
*.pyc
*.jar
*.war
*.nar
*.ear
*.zip
*.tar.gz
*.rar
hs_err_pid*
replay_pid*

# Gradle and build outputs
.gradle/
build/
bin/
out/
.micronaut-cli.yml.tmp
**/build/
**/out/

# IDE and editor configuration
.idea/
*.iml
*.iws
*.ipr
.vscode/
.classpath
.project
.settings/
.factorypath

# Postman and Newman local reports
reports/
*.html
PostMan-Collection/*.data.json
PostMan-Collection/*_working_copy.json
PostMan-Collection/*.bak

# Logs and temporary files
*.log
logs/
*.tmp
*.bak
*.swp
.DS_Store
Thumbs.db
'@

    Write-Host "Writing .gitignore..." -ForegroundColor Yellow
    Set-Content -Path ".gitignore" -Value $gitignoreContent -Encoding utf8

    Write-Host "Removing tracked build, cache, and IDE files..." -ForegroundColor Yellow
    $cachedPaths = @(
        "build/", ".gradle/", ".idea/", "bin/", "out/", "*.iml"
    )
    foreach ($cachedPath in $cachedPaths) {
        & git rm -r --cached --ignore-unmatch -- $cachedPath
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to remove '$cachedPath' from the Git index."
        }
    }

    Write-Host "Staging .gitignore and index changes..." -ForegroundColor Yellow
    & git add .
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to stage Git changes."
    }

    Write-Host "Committing security hardening changes..." -ForegroundColor Yellow
    & git commit -m "security: apply gitignore and untrack local artifacts"
    if ($LASTEXITCODE -ne 0) {
        throw "Git commit failed. Review the repository status and commit output."
    }

    Write-Host "Git security hardening completed successfully." -ForegroundColor Green
}
finally {
    Pop-Location
}