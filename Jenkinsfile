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
            environment {
                SSH_CRED = credentials('ssh_key')  // SSH Username with Private Key credential ID in Jenkins
            }
            steps {
                powershell '''
                    # Write private key content to a temp file
                    
                    

                    #Set-Content -Path $keyPath -Value $privateKeyContent -Force

                    # Define parameters for migrate.ps1
                    $sourceFile = "C:\\Users\\Admin-BL\\Desktop\\UserswithoutDB\\UserswithoutDB\\bin\\Debug\\net8.0\\users.json"
                    $remoteUser = "admin"
                    $remoteIP   = "104.154.40.124"
                    $destinationPath = "C:/Users/Admin/Desktop/users.json"

                    $scriptPath = "$PWD\\migrate.ps1"

                    if (!(Test-Path $scriptPath)) {
                        Write-Error "migrate.ps1 script not found."
                        exit 1
                    }

                    # Run migrate.ps1 with parameters
                    & $scriptPath `
                        -SourceFile $sourceFile `
                        -RemoteUser $remoteUser `
                        -RemoteIP $remoteIP `
                        -PrivateKeyPath $SSH_CRED `
                        -DestinationPath $destinationPath

                    if ($LASTEXITCODE -ne 0) {
                        Write-Error "Migration script failed."
                        exit 1
                    }
                '''
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
