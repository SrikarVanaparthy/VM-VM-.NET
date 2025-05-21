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
                        Write-Host "🔐 Preparing SSH key..."

                        try {
                            Write-Host "Copying SSH private key to workspace..."
                            Copy-Item -Path "$env:SSH_KEY_PATH" -Destination $keyPath -Force -ErrorAction Stop
                        } catch {
                            Write-Error "❌ Failed to copy SSH key: $_"
                            exit 1
                        }

                        Write-Host "Setting secure permissions on private key file..."
                        try {
                            icacls $keyPath /inheritance:r | Out-Null
                            icacls $keyPath /grant:r "BUILTIN\\Administrators:R" | Out-Null
                            icacls $keyPath /remove "Users" | Out-Null
                        } catch {
                            Write-Error "❌ Failed to set file permissions: $_"
                            exit 1
                        }

                        $sourceFile = "C:\\Users\\Admin-BL\\Desktop\\UserswithoutDB\\UserswithoutDB\\bin\\Debug\\net8.0\\users.json"
                        $remoteUser = "$env:SSH_USER"
                        $remoteIP   = "104.154.40.124"
                        $destinationPath = "C:/Users/Admin/Desktop/users.json"
                        $scriptPath = "./migrate.ps1"

                        Write-Host "🚀 Starting migration..."
                        & $scriptPath `
                            -SourceFile $sourceFile `
                            -RemoteUser $remoteUser `
                            -RemoteIP $remoteIP `
                            -PrivateKeyPath $keyPath `
                            -DestinationPath $destinationPath

                        if ($LASTEXITCODE -ne 0) {
                            Write-Error "❌ Migration script failed with exit code $LASTEXITCODE"
                            exit 1
                        }

                        Write-Host "✅ Migration script executed successfully."
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅ File transfer and migration completed successfully.'
        }
        failure {
            echo '❌ Migration failed. Please check the logs.'
        }
    }
}
