param([string]$OutputDirectory = "inventory")
$ErrorActionPreference = "Stop"
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$bios = Get-CimInstance Win32_Bios
$computer = Get-CimInstance Win32_ComputerSystem
$operatingSystem = Get-CimInstance Win32_OperatingSystem
$processor = Get-CimInstance Win32_Processor | Select-Object -First 1
$memoryModules = @(Get-CimInstance Win32_PhysicalMemory)
$disks = @(Get-PhysicalDisk | Sort-Object DeviceId)
$graphics = @(Get-CimInstance Win32_VideoController)
$memoryTotalGb = [Math]::Round((($memoryModules | Measure-Object Capacity -Sum).Sum) / 1GB)
$diskTotalGb = [Math]::Round((($disks | Measure-Object Size -Sum).Sum) / 1GB)
$specifications = [ordered]@{
	processorModel = $processor.Name.Trim()
	processorCores = $processor.NumberOfCores
	processorThreads = $processor.NumberOfLogicalProcessors
	memoryModuleCount = $memoryModules.Count
	memoryTotalGb = $memoryTotalGb
	diskTotalGb = $diskTotalGb
	graphicsAdapters = @($graphics.Name)
}
$base = [ordered]@{
	serialNumber = $bios.SerialNumber
	manufacturerName = $computer.Manufacturer
	modelName = $computer.Model
	hostName = $computer.Name
	installedSystem = $operatingSystem.Caption
	systemVersion = $operatingSystem.Version
	active = $true
	specifications = $specifications
}
$manual = [ordered]@{} + $base
$manual.itemType = "REPLACE_WITH_ASSET_TYPE"
$manual.acquisitionDate = "REPLACE_WITH_DATE"
$manual.activationDate = "REPLACE_WITH_DATE"
$manual.specifications = [ordered]@{} + $specifications
$manual.specifications.screen = "REPLACE_WITH_DISPLAY_DETAILS"
$manual.warranties = "REPLACE_WITH_WARRANTY_DETAILS"
$nullFields = [ordered]@{} + $base
$nullFields.itemType = $null
$nullFields.acquisitionDate = $null
$nullFields.activationDate = $null
$nullFields.warranties = $null
$manual | ConvertTo-Json -Depth 8 | Set-Content (Join-Path $OutputDirectory "inventory-with-placeholders.json")
$nullFields | ConvertTo-Json -Depth 8 | Set-Content (Join-Path $OutputDirectory "inventory-with-null-fields.json")