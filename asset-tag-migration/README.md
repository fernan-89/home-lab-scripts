# Asset Tag Migration

Adds sequential `assetTag` values to JSON objects or to every object in a JSON array. Files are overwritten in place.

Prerequisites: PowerShell with JSON cmdlets, or Bash with `jq`. Back up the input directory before running.

PowerShell: `./update-asset-tags.ps1 -JsonDirectory C:\path\to\json -AssetTagPrefix ASSET- -StartNumber 1`

Bash: `ASSET_TAG_PREFIX=ASSET- START_NUMBER=1 ./update-asset-tags.sh /path/to/json`