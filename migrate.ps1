param (
    [string]$SourceFile,
    [string]$RemoteUser,
    [string]$RemoteIP,
    [string]$PrivateKeyPath,
    [string]$DestinationPath
)

if (-not (Test-Path $PrivateKeyPath)) {
    Write-Error "Private key file not found at: $PrivateKeyPath"
    exit 1
}

$remoteTarget = "${RemoteUser}@${RemoteIP}:`"$DestinationPath`""

$scpArgs = @(
    "-i", $PrivateKeyPath,
    "-o", "StrictHostKeyChecking=no",
    $SourceFile,
    $remoteTarget
)

Write-Host "Starting SCP transfer..."

# Use & scp directly (simpler than Start-Process here)
& scp @scpArgs

if ($LASTEXITCODE -ne 0) {
    Write-Error "File transfer failed with exit code $LASTEXITCODE"
    exit 1
}

Write-Host "File transfer completed successfully."
