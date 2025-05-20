pipeline {
    agent any

    stages {

        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/SrikarVanaparthy/VM-VM-.NET.git', branch: 'main'
            }
        }




        stage('Run Migration Script') {
            steps {
                powershell '''
                # Run migrate.ps1 from the workspace root
                & "$PWD\\migrate.ps1"
                '''
            }
        }
    }
}
