# Network Performance

Prerequisites: ICMP access and the `ping` utility. Optional download tests use trusted HTTPS URLs supplied by the operator; certificate validation is never disabled.

PowerShell: `./measure-network.ps1 -ProbeHost example.com -Count 4 -DownloadUrl https://example.com/test.bin`

Bash: `PING_COUNT=4 NETWORK_TEST_URLS=https://example.com/test.bin ./measure-network.sh example.com`