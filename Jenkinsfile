pipeline {

    agent any

    stages {
    
        stage("build") {
            agent {
                docker {
                    image 'python:3'
                    args '-u'
                }
            }

            steps {
                dir('./first_project') {
                sh 'echo "Working directory is: $(pwd)"'
                echo 'Building the app.'
                sh 'pip install -r requirements.txt'
                sh 'python3 app.py'
                }
            }
        }

        stage("test") {

            steps {
                echo 'Testing the app.'
                dir('./first_project') {
                sh 'echo "Working directory is: $(pwd)"'
                sh 'pytest test_apy.py'
               }
            }
        }
    }
}
