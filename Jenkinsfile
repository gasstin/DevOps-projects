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
                sh './first_project/setup_enviroment.sh'
                sh 'make -f ./first_project/server_setup.mk start'
            }
        }
    }
}