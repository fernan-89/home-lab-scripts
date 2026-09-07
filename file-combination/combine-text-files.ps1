param(
    [string]$InputDirectory = (Get-Location).Path,
    [string]$OutputFile = "combined.txt"
)

$ErrorActionPreference = "Stop"
$resolvedInput = (Resolve-Path -LiteralPath $InputDirectory).Path
$resolvedOutput = [System.IO.Path]::GetFullPath((Join-Path $resolvedInput $OutputFile))
$files = @(Get-ChildItem -LiteralPath $resolvedInput -Filter "*.txt" -File | Where-Object { $_.FullName -ne $resolvedOutput } | Sort-Object Name)
Get-Content -LiteralPath $files.FullName | Set-Content -LiteralPath $resolvedOutput -Encoding utf8
Write-Output "Combined $($files.Count) text files into $resolvedOutput."