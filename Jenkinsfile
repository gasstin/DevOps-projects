pipeline {

    agent any

    stages {

        stage("build") {

            steps {
                dir('./first_project') {
                sh 'echo "Working directory is: $(pwd)"'
                echo 'Building the app.'
                sh './setup_enviroment.sh '
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
