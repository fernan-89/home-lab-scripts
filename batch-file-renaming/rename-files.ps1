param(
    [Parameter(Mandatory)] [string]$Directory,
    [Parameter(Mandatory)] [string]$FirstWord,
    [Parameter(Mandatory)] [string]$SecondWord,
    [switch]$Apply
)

$ErrorActionPreference = "Stop"
if (-not (Test-Path -LiteralPath $Directory -PathType Container)) { throw "Directory does not exist: $Directory" }
$firstTrimmed = $FirstWord.Trim().ToLowerInvariant()
$secondTrimmed = $SecondWord.Trim().ToLowerInvariant()
if (-not $firstTrimmed -or -not $secondTrimmed) { throw "Both naming words are required." }
$prefix = ("{0}-{1}" -f $firstTrimmed.Substring(0, [Math]::Min(3, $firstTrimmed.Length)), $secondTrimmed.Substring(0, [Math]::Min(3, $secondTrimmed.Length))).ToUpperInvariant()
$dateTag = Get-Date -Format "yyyyMMdd"
$characters = "ABCDEFGHJKLMNOPQRSTUVWXYZ0123456789"
$counter = 1
$changes = foreach ($file in Get-ChildItem -LiteralPath $Directory -File | Sort-Object Name) {
    $hash = -join (1..9 | ForEach-Object { $characters[(Get-Random -Maximum $characters.Length)] })
    [PSCustomObject]@{ File = $file; NewName = "{0}-{1:D3}-{2}-{3}{4}" -f $prefix, $counter, $hash, $dateTag, $file.Extension }
    $counter++
}
if (-not $changes) { Write-Output "No files found."; exit 0 }
$changes | ForEach-Object { Write-Output "Proposed: '$($_.File.Name)' -> '$($_.NewName)'" }
if (-not $Apply) { Write-Output "Dry run only. Re-run with -Apply to rename files."; exit 0 }
foreach ($change in $changes) { Rename-Item -LiteralPath $change.File.FullName -NewName $change.NewName }