param (
    [string]$SourceFile,
    [string]$RemoteUser,
    [string]$RemoteIP,
    [string]$PrivateKeyPath,
    [string]$DestinationPath
)

# Ensure the key file exists
if (-not (Test-Path $PrivateKeyPath)) {
    Write-Error "Private key file not found at: $PrivateKeyPath"
    exit 1
}

# Secure the key file permissions (required by SSH)
Write-Host "Setting secure permissions on private key file: $PrivateKeyPath"
icacls $PrivateKeyPath /inheritance:r | Out-Null
icacls $PrivateKeyPath /grant:r "$($env:USERNAME):(R)" | Out-Null
icacls $PrivateKeyPath /remove "Users" | Out-Null

# Construct remote destination path
$remoteTarget = "${RemoteUser}@${RemoteIP}:`"$DestinationPath`""

# Build SCP command arguments
$scpArgs = @(
    "-i", "`"$PrivateKeyPath`"",
    "-o", "StrictHostKeyChecking=no",
    "`"$SourceFile`"",
    $remoteTarget
)

Write-Host "Starting SCP transfer..."
& scp @scpArgs

if ($LASTEXITCODE -ne 0) {
    Write-Error " File transfer failed with exit code $LASTEXITCODE"
    exit 1
}

Write-Host "File transfer completed successfully."
