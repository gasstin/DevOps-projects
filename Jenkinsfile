pipeline {
    agent {
        docker {
        image 'python:3.10-alpine'
        args '-u root'
        }
    }
    stages {
        stage('Build') { 
            steps {
                sh './first_project/setup_enviroment.sh'
            }
        }
    }
}