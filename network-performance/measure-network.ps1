param([string[]]$ProbeHost = $(if ($env:NETWORK_PROBE_HOSTS) { $env:NETWORK_PROBE_HOSTS -split ',' } else { @("example.com") }), [int]$Count = 4, [uri[]]$DownloadUrl = $(if ($env:NETWORK_TEST_URLS) { $env:NETWORK_TEST_URLS -split ',' } else { @() }), [string]$OutputFile = "network-performance.json")
$ErrorActionPreference = "Stop"
$latency = foreach ($hostName in $ProbeHost) {
	$samples = @(Test-Connection -ComputerName $hostName -Count $Count -ErrorAction SilentlyContinue | Select-Object Address,ResponseTime)
	[ordered]@{ ProbeHost = $hostName; Samples = $samples; AverageMilliseconds = $(if ($samples.Count) { [Math]::Round(($samples.ResponseTime | Measure-Object -Average).Average, 2) } else { $null }); JitterMilliseconds = $(if ($samples.Count) { ($samples.ResponseTime | Measure-Object -Maximum).Maximum - ($samples.ResponseTime | Measure-Object -Minimum).Minimum } else { $null }) }
}
$downloads = foreach ($url in $DownloadUrl) {
	try {
		$watch = [System.Diagnostics.Stopwatch]::StartNew()
		$response = Invoke-WebRequest -Uri $url -TimeoutSec 30 -UseBasicParsing
		$watch.Stop()
		[ordered]@{ Url = $url.AbsoluteUri; Bytes = $response.RawContentLength; Seconds = [Math]::Round($watch.Elapsed.TotalSeconds, 2); MegabitsPerSecond = [Math]::Round(($response.RawContentLength * 8 / 1MB) / $watch.Elapsed.TotalSeconds, 2) }
	} catch { [ordered]@{ Url = $url.AbsoluteUri; Error = $_.Exception.Message } }
}
$result = [ordered]@{ Timestamp = (Get-Date).ToUniversalTime().ToString("o"); Latency = @($latency); Downloads = @($downloads) }
$result | ConvertTo-Json -Depth 5 | Set-Content $OutputFile