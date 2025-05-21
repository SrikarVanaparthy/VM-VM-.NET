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

# Use BUILTIN\\Administrators or the exact Jenkins user account if known
Write-Host "Setting secure permissions on private key..."
icacls $PrivateKeyPath /inheritance:r
icacls $PrivateKeyPath /grant:r "BUILTIN\\Administrators:R"
icacls $PrivateKeyPath /remove "Users"

$remoteTarget = "${RemoteUser}@${RemoteIP}:`"$DestinationPath`""

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
