param (
    [string]$SourceFile,
    [string]$RemoteUser,
    [string]$RemoteIP,
    [string]$PrivateKeyPath,
    [string]$DestinationPath
)

# Set secure permissions on the SSH private key file (Windows-safe)
Write-Host "🔐 Setting secure permissions on private key file: $PrivateKeyPath"
icacls $PrivateKeyPath /inheritance:r | Out-Null
icacls $PrivateKeyPath /grant:r "$($env:USERNAME):(R)" | Out-Null
icacls $PrivateKeyPath /remove "Users" | Out-Null

# Construct full remote SCP path
$remoteTarget = "${RemoteUser}@${RemoteIP}:`"$DestinationPath`""

# Prepare SCP arguments to avoid quoting issues
$scpArgs = @(
    "-i", "$PrivateKeyPath",
    "-o", "StrictHostKeyChecking=no",
    "$SourceFile",
    "$remoteTarget"
)

Write-Host "🚀 Starting SCP transfer..."
Start-Process -FilePath "scp" -ArgumentList $scpArgs -NoNewWindow -Wait

if ($LASTEXITCODE -ne 0) {
    Write-Error "❌ File transfer failed with exit code $LASTEXITCODE"
    exit 1
}

Write-Host "✅ File transfer completed successfully."
