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
                // Bind SSH key file path and username to environment variables
                withCredentials([sshUserPrivateKey(credentialsId: 'ssh_key', keyFileVariable: 'SSH_KEY_PATH', usernameVariable: 'SSH_USER')]) {
                    powershell '''
                        $sourceFile = "C:\\Users\\Admin-BL\\Desktop\\UserswithoutDB\\UserswithoutDB\\bin\\Debug\\net8.0\\users.json"
                        $remoteUser = "admin"
                        $remoteIP = "104.154.40.124"
                        $destinationPath = "C:/Users/Admin/Desktop/users.json"
                        $privateKeyPath = "$env:SSH_KEY_PATH"
                        
                        $scriptPath = "$PWD\\migrate.ps1"
                        
                        if (!(Test-Path $scriptPath)) {
                            Write-Error "migrate.ps1 script not found."
                            exit 1
                        }
                        
                        # Run the migration script with parameters
                        & $scriptPath `
                            -SourceFile $sourceFile `
                            -RemoteUser $remoteUser `
                            -RemoteIP $remoteIP `
                            -PrivateKeyPath $privateKeyPath `
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

    post {
        success {
            echo '✅ File transfer and migration completed successfully.'
        }
        failure {
            echo '❌ Migration failed. Please check the logs.'
        }
    }
}
