pipeline {

    agent any

    stages {

        stage("build") {

            steps {
                sh 'source venv/bin/active'
                echo 'Building the app.'

            }
        }

        stage("test") {

            steps {
                echo 'Testing the app.'
                sh 'pytest test_apy.py'
            }
        }
    }
}
