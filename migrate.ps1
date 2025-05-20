$sourceFile = "C:\\Users\\Admin-BL\\Desktop\\UserswithoutDB\\UserswithoutDB\\bin\\Debug\\net8.0\\users.json"
$remoteUser = "admin"
$remoteIP = "104.154.40.124"
$privateKeyPath = "C:\\Users\\Admin-BL\\.ssh\\id_rsa"

$destination = $remoteUser + "@" + $remoteIP + ":'C:/Users/Admin/Desktop/'"



scp -i "$privateKeyPath" -o StrictHostKeyChecking=no `
    "$sourceFile" "$destination"


# # PowerShell: Transfer user.json from VM1 to VM2

# # Source (VM1)
# $sourceFile = "C:\Users\Admin-BL\Desktop\UserswithoutDB\UserswithoutDB\bin\Debug\net8.0\users.json"

# # Destination (VM2)
# $destinationVM = "104.154.40.124"
# $destinationPath = "\\$destinationVM\C$\Users\Admin\Desktop"

# # Optional: Credentials if needed for file sharing
# # $cred = Get-Credential
# # New-PSDrive -Name Z -PSProvider FileSystem -Root "\\$destinationVM\C$" -Credential $cred

# # Copy file to VM2
# Copy-Item -Path $sourceFile -Destination $destinationPath -Force

# Write-Host "File transferred to VM2 at $destinationPath"
