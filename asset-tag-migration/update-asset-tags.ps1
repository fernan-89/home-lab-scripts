param(
    [Parameter(Mandatory)]
    [string]$JsonDirectory,
    [string]$AssetTagPrefix = $(if ($env:ASSET_TAG_PREFIX) { $env:ASSET_TAG_PREFIX } else { "ASSET-" }),
    [int]$StartNumber = 1
)

$ErrorActionPreference = "Stop"
if (-not (Test-Path -LiteralPath $JsonDirectory -PathType Container)) { throw "The JSON directory does not exist: $JsonDirectory" }
$counter = $StartNumber
$jsonFiles = @(Get-ChildItem -LiteralPath $JsonDirectory -Filter "*.json" -File | Sort-Object Name)
Write-Output "Found $($jsonFiles.Count) JSON files."

foreach ($jsonFile in $jsonFiles) {
    $data = Get-Content -LiteralPath $jsonFile.FullName -Raw | ConvertFrom-Json
    $items = if ($data -is [Array]) { $data } else { @($data) }
    foreach ($item in $items) {
        $item.assetTag = $AssetTagPrefix + $counter.ToString("D3")
        $counter++
    }
    $output = if ($data -is [Array]) { $items } else { $items[0] }
    $output | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $jsonFile.FullName -Encoding utf8
    Write-Output "Updated $($jsonFile.Name); next number: $counter"
}