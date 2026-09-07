param(
    [Parameter(Mandatory)] [string]$RepositoryPath,
    [string]$GitIgnoreLanguage = "PowerShell",
    [string]$RepositoryName = (Split-Path -Leaf (Resolve-Path $RepositoryPath)),
    [ValidateSet("public", "private", "internal")] [string]$Visibility = "private"
)
$ErrorActionPreference = "Stop"
foreach ($command in @("git", "gh")) { if (-not (Get-Command $command -ErrorAction SilentlyContinue)) { throw "$command is required." } }
gh auth status 2>$null
if ($LASTEXITCODE -ne 0) { throw "Authenticate GitHub CLI with 'gh auth login' before running this script." }
if (-not (Test-Path -LiteralPath $RepositoryPath -PathType Container)) { throw "Repository path does not exist." }
Push-Location (Resolve-Path $RepositoryPath)
try {
    if (-not (Test-Path .git)) { git init --initial-branch=developer }
    $template = gh api "gitignore/templates/$($GitIgnoreLanguage.ToLowerInvariant())" --jq '.source' 2>$null
    if ($template) { $template | Set-Content .gitignore -Encoding utf8 }
    $workflowPath = Join-Path ".github" "workflows"
    New-Item -ItemType Directory -Path $workflowPath -Force | Out-Null
    @"
name: Promote Developer To Stage
on:
  push:
    branches: [developer]
jobs:
  promote:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with: {fetch-depth: 0}
      - run: git push origin HEAD:stage
"@ | Set-Content (Join-Path $workflowPath "promote-developer-to-stage.yml")
    @"
name: Validate Pull Request
on:
  pull_request:
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: git status --short
"@ | Set-Content (Join-Path $workflowPath "validate-pull-request.yml")
    git add .
    git diff --cached --quiet; if ($LASTEXITCODE -ne 0) { git commit -m "chore: configure repository workflows" }
    foreach ($branch in @("stage", "master")) { git branch $branch 2>$null }
    gh repo create $RepositoryName --$Visibility --source=. --remote=origin --push 2>$null
    git push -u origin developer
    git push -u origin stage
    git push -u origin master
}
finally { Pop-Location }