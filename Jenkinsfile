pipeline {
    agent any

    environment {
        // Git repository
        REPO_URL = 'https://github.com/SrikarVanaparthy/VM-VM-.NET.git'

        // SSH key for authentication (secured and readable only by Jenkins)
        SSH_KEY_PATH = 'C:/Jenkins/ssh/id_rsa'
    }

    stages {

        stage('Checkout Code') {
            steps {
                git url: "${env.REPO_URL}", branch: 'main'
            }
        }

        stage('Run Migration Script') {
            steps {
                powershell '''
                    Write-Host "Running migrate.ps1 to transfer users.json..."

                    # Define script path in workspace
                    $scriptPath = "$PWD\\migrate.ps1"

                    if (!(Test-Path $scriptPath)) {
                        Write-Error "migrate.ps1 not found in workspace."
                        exit 1
                    }

                    # Run your PowerShell script which uses scp + SSH key
                    & $scriptPath

                    if ($LASTEXITCODE -ne 0) {
                        Write-Error " migrate.ps1 execution failed."
                        exit 1
                    }

                    Write-Host "migrate.ps1 executed successfully."
                '''
            }
        }
    }

    post {
        success {
            echo '🎉 File transfer and migration succeeded.'
        }
        failure {
            echo 'Migration failed. Please check console logs.'
        }
    }
}
