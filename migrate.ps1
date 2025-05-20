param (
    [string]$SourceFile,
    [string]$RemoteUser,
    [string]$RemoteIP,
    [string]$PrivateKeyPath,
    [string]$DestinationPath
)


# Construct full remote SCP path
$remoteTarget = "${RemoteUser}@${RemoteIP}:`"$DestinationPath`""

# Prepare SCP arguments to avoid quoting issues
$scpArgs = @(
    "-i", "$PrivateKeyPath",
    "-o", "StrictHostKeyChecking=no",
    "$SourceFile",
    "$remoteTarget"
)

Write-Host "Starting SCP transfer..."
Start-Process -FilePath "scp" -ArgumentList $scpArgs -NoNewWindow -Wait

if ($LASTEXITCODE -ne 0) {
    Write-Error " File transfer failed with exit code $LASTEXITCODE"
    exit 1
}


