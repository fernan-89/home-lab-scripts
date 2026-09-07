param(
    [string]$RootPath = (Get-Location).Path,
    [switch]$Recurse,
    [string]$OutputFile = "README_INDEX.md"
)
$ErrorActionPreference = "Stop"
$root = (Resolve-Path -LiteralPath $RootPath).Path
$files = if ($Recurse) { @(Get-ChildItem $root -File -Recurse) } else { @(Get-ChildItem $root -File) }
$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add("# Repository Index")
$lines.Add("")
$lines.Add("| File | Type | Size | Last Modified |")
$lines.Add("| --- | --- | ---: | --- |")
foreach ($file in ($files | Sort-Object FullName)) {
    if ($file.Name -eq $OutputFile) { continue }
    $relative = $file.FullName.Substring($root.Length).TrimStart('\','/').Replace('\','/')
    $type = if ($file.Extension) { $file.Extension.TrimStart('.').ToUpperInvariant() } else { "FILE" }
    $lines.Add("| [$relative]($relative) | $type | $($file.Length) | $($file.LastWriteTimeUtc.ToString('yyyy-MM-ddTHH:mm:ssZ')) |")
}
Set-Content -LiteralPath (Join-Path $root $OutputFile) -Value $lines -Encoding utf8
Write-Output "Repository index written to $(Join-Path $root $OutputFile)."
