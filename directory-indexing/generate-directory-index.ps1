param([string]$RootPath = (Get-Location).Path, [int]$MaxDepth = 0, [string]$OutputFile = "README.md")
$ErrorActionPreference = "Stop"
$root = (Resolve-Path $RootPath).Path
$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add("# Directory Index")
Get-ChildItem $root -Directory -Recurse | Where-Object { $MaxDepth -le 0 -or $_.FullName.Substring($root.Length).Split([IO.Path]::DirectorySeparatorChar).Count -le $MaxDepth } | Sort-Object FullName | ForEach-Object { $relative = $_.FullName.Substring($root.Length).TrimStart('\','/').Replace('\','/'); $lines.Add("- [$relative]($relative/)") }
Set-Content (Join-Path $root $OutputFile) $lines