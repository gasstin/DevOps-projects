pipeline {
    agent {
        docker {
        image 'gasstin/jenkins_dind:latest'
        args '-u root'
        }
    }

    stages {
        stage('Build') { 
            steps {
                sh 'pip install -r requirements.txt'
                sh 'make -f ./first_project/server_setup.mk start'
            }
        }
    }
}