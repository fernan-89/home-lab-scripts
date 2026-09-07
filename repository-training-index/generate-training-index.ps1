param(
    [string]$RootPath = (Get-Location).Path,
    [string]$OutputFile = "base_treinamento.md"
)

$ErrorActionPreference = "Stop"
$root = (Resolve-Path -LiteralPath $RootPath).Path
$outputPath = Join-Path $root $OutputFile
$excludedNames = @(".git", ".idea", ".gradle", "build", "bin", "obj")
$excludedFiles = @("gerar_base.ps1", "generate-training-index.ps1", "base_treinamento.md")

$files = Get-ChildItem -LiteralPath $root -File -Recurse |
    Where-Object {
        $pathParts = $_.FullName -split '[\\/]'
        $insideExcludedDirectory = @($pathParts | Where-Object { $_ -in $excludedNames }).Count -gt 0
        $_.Name -notin $excludedFiles -and
        -not $insideExcludedDirectory
    } |
    Sort-Object FullName

$lines = [System.Collections.Generic.List[string]]::new()
foreach ($file in $files) {
    $relative = $file.FullName.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
    $lines.Add("## File: $relative")
    $lines.Add('```')
    $lines.AddRange([string[]](Get-Content -LiteralPath $file.FullName))
    $lines.Add('```')
    $lines.Add('')
}

Set-Content -LiteralPath $outputPath -Value $lines -Encoding utf8
Write-Output "Training index written to $outputPath."
