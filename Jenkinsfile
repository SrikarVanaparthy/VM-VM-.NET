pipeline {
    agent any

    stages {
        stage('Transfer JSON to VM2') {
            steps {
                powershell '''
                $sourceFile = "C:\\Users\\Admin-BL\\Desktop\\UserswithoutDB\\UserswithoutDB\\bin\\Debug\\net8.0\\users.json"
                $remoteUser = "your_vm2_username"
                $remoteIP = "104.154.40.124"
                $privateKeyPath = "C:\\Users\\Jenkins\\.ssh\\id_rsa"
                $destinationPath = "$remoteUser@$remoteIP:/C:/Users/Admin/Desktop/"

                scp -i "$privateKeyPath" -o StrictHostKeyChecking=no `
                    "$sourceFile" "$destinationPath"
                '''
            }
        }

        stage('Launch .NET App on VM2') {
            steps {
                powershell '''
                $remoteUser = "your_vm2_username"
                $remoteIP = "104.154.40.124"
                $privateKeyPath = "C:\\Users\\Jenkins\\.ssh\\id_rsa"

                ssh -i "$privateKeyPath" -o StrictHostKeyChecking=no `
                    "$remoteUser@$remoteIP" `
                    "Start-Process 'C:\\Users\\Admin\\Desktop\\YourApp.exe'"
                '''
            }
        }
    }
}
