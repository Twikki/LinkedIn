# Get the GUID of the High Performance power scheme
$highPerf = powercfg -l | Where-Object { $_ -match "High performance" } | ForEach-Object { ($_ -split '\s+')[3] }

# Set it as active
if ($highPerf) {
    powercfg -setactive $highPerf
    Write-Host "High Performance power plan activated." -ForegroundColor Green
} else {
    Write-Host "High Performance plan not found!" -ForegroundColor Red
}