pipeline {
    agent any

    stages {
        stage('check the versions'){
            steps {
                sh '''
                   pwd
                   ls -la
                   node -v
                   npm -v
                   docker version
                '''
            }

            stage('npm installation'){
                steps {
                    sh '''
                        npm Install
                    '''
                }
            }

            stage('Debug'){
                steps {
                    sh '''
                        npm test -- --watchAll=false
                    '''
                }
            }

        }
    }

}