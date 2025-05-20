param (
    [string]$SourceFile,
    [string]$RemoteUser,
    [string]$RemoteIP,
    [string]$PrivateKeyPath,
    [string]$DestinationPath
)

# Check if key exists
if (-not (Test-Path $PrivateKeyPath)) {
    Write-Error "Private key file not found at: $PrivateKeyPath"
    exit 1
}

# Optional: reset permissions again just in case
Write-Host "Setting secure permissions on private key..."
icacls $PrivateKeyPath /inheritance:r /grant:r "$env:USERNAME:R" /c | Out-Null

# Build remote destination
$remoteTarget = "${RemoteUser}@${RemoteIP}:`"$DestinationPath`""

# SCP arguments
$scpArgs = @(
    "-i", "`"$PrivateKeyPath`"",
    "-o", "StrictHostKeyChecking=no",
    "`"$SourceFile`"",
    $remoteTarget
)

Write-Host "Starting SCP transfer..."
& scp @scpArgs

if ($LASTEXITCODE -ne 0) {
    Write-Error "File transfer failed with exit code $LASTEXITCODE"
    exit 1
}

Write-Host "✅ File transfer completed successfully."
