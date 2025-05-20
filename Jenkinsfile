pipeline {
    agent any

    stages {
        stage('Transfer JSON to VM2') {
            steps {
                powershell '''
                # PowerShell commands (same as above)
                $sourceFile = "C:\\Users\\Admin-BL\\Desktop\\UserswithoutDB\\UserswithoutDB\\bin\\Debug\\net8.0\\users.json"
                $destinationVM = "104.154.40.124"
                $destinationPath = "\\\\$destinationVM\\C$\\Users\\Admin\\Desktop"
                Copy-Item -Path $sourceFile -Destination $destinationPath -Force
                '''
            }
        }

        stage('Launch .NET App on VM2') {
            steps {
                powershell '''
                Invoke-Command -ComputerName "104.154.40.124" -ScriptBlock {
                    Start-Process "C:\\Users\\Admin-BL\\Desktop"
                }
                '''
            }
        }
    }
}
