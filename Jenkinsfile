pipeline {
    agent any

    environment {
    REPO_URL = 'https://github.com/SrikarVanaparthy/VM-VM-.NET.git'
}

stages {
    stage('Checkout Code') {
        steps {
            git url: "${env.REPO_URL}", branch: 'main'
        }
    }

    stage('Run Migration Script') {
        steps {
            withCredentials([sshUserPrivateKey(credentialsId: 'ssh_key', keyFileVariable: 'SSH_KEY_PATH', usernameVariable: 'SSH_USER')]) {
                powershell '''
                    $keyPath = "$env:WORKSPACE\\jenkins_id_rsa"
                    Copy-Item -Path "$env:SSH_KEY_PATH" -Destination $keyPath -Force

                    # Strict file permissions (OpenSSH-compatible)
                    $acl = Get-Acl $keyPath
                    $acl.SetAccessRuleProtection($true, $false)
                    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($env:USERNAME, "Read", "Allow")
                    $acl.SetAccessRule($rule)
                    Set-Acl -Path $keyPath -AclObject $acl


                    $sourceFile = "C:\\Users\\Admin-BL\\Desktop\\UserswithoutDB\\UserswithoutDB\\bin\\Debug\\net8.0\\users.json"
                    $remoteUser = "$env:SSH_USER"
                    $remoteIP   = "104.154.40.124"
                    $destinationPath = "C:/Users/Admin/Desktop/users.json"

                    $scriptPath = "./migrate.ps1"

                    & $scriptPath `
                        -SourceFile $sourceFile `
                        -RemoteUser $remoteUser `
                        -RemoteIP $remoteIP `
                        -PrivateKeyPath $keyPath `
                        -DestinationPath $destinationPath

                    if ($LASTEXITCODE -ne 0) {
                        Write-Error "Migration script failed."
                        exit 1
                    }
                '''
            }
        }
    }
}

}
