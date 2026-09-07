param(
    [Parameter(Mandatory)] [string]$RootPath,
    [Parameter(Mandatory)] [string]$OutputPath
)
$ErrorActionPreference = "Stop"
if (-not (Test-Path -LiteralPath $RootPath -PathType Container)) { throw "Root path does not exist: $RootPath" }
$files = @(Get-ChildItem -LiteralPath $RootPath -Filter "*.tf" -Recurse -File | Sort-Object FullName)
if (-not $files) { throw "No Terraform files were found." }
$blocks = foreach ($file in $files) { "## File: $($file.FullName)`n````hcl`n$(Get-Content -LiteralPath $file.FullName -Raw)`````n`n---" }
$blocks -join "`n" | Set-Content -LiteralPath $OutputPath -Encoding utf8
Write-Output "Documented $($files.Count) Terraform files in $OutputPath."