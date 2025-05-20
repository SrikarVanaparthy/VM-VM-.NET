param (
    [string]$SourceFile,
    [string]$RemoteUser,
    [string]$RemoteIP,
    [string]$PrivateKeyPath,
    [string]$DestinationPath
)

# Set secure permissions on private key file (Windows)
Write-Host "Setting secure permissions on private key file: $PrivateKeyPath"
icacls $PrivateKeyPath /inheritance:r | Out-Null
icacls $PrivateKeyPath /grant:r "$($env:USERNAME):(R)" | Out-Null
icacls $PrivateKeyPath /remove "Users" | Out-Null

# Build the destination string correctly
$remoteFullPath = "${RemoteUser}@${RemoteIP}:`"$DestinationPath`""

# Run SCP to transfer file
Write-Host "Starting file transfer..."
scp -i "$PrivateKeyPath" -o StrictHostKeyChecking=no "$SourceFile" $remoteFullPath

if ($LASTEXITCODE -ne 0) {
    Write-Error "File transfer failed with exit code $LASTEXITCODE"
    exit 1
}

Write-Host "File transfer completed successfully."
