pipeline{
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
            }

            stage('npm installation'){
                steps {
                    sh '''
                        npm Install
                    '''
                }
            }


            stage('SonarQube Analysis'){

                steps {
                        script {

                        def scannerHome = tool(
                            name: 'sonar-scanner',
                            type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                        )

                        withSonarQubeEnv('sonarqube') {
                            sh "${scannerHome}/bin/sonar-scanner"
                        }
                    }
                }
            }

            stage('Quality Gate') {
                steps {
                    timeout(time: 5, unit: 'MINUTES') {
                        waitForQualityGate abortPipeline: true
                    }
                }
            }

            stage('Build Application') {
                steps {
                    dir('innerpeace') {
                        sh 'npm run build'
                    }
                }
            }

            stage('Run Tests') {
                steps {
                    dir('innerpeace') {
                        sh 'CI=true npm test -- --watchAll=false'
                    }
                }
            }

            stage('Build Docker Image') {
                steps {
                    dir('innerpeace') {

                        sh """
                        docker build \
                        -t ${IMAGE_NAME}:${IMAGE_TAG} \
                        -t ${IMAGE_NAME}:latest .
                        """

                    }
                }
            }

            stage('Trivy Scan') {
                steps {

                    sh """
                    mkdir -p \$WORKSPACE/.trivycache

                    docker run --rm \
                    -v \$WORKSPACE/.trivycache:/root/.cache/trivy \
                    -v /var/run/docker.sock:/var/run/docker.sock \
                    aquasec/trivy:latest image \
                    --severity HIGH,CRITICAL \
                    ${IMAGE_NAME}:${IMAGE_TAG}
                    """

                }
            }

            stage('Push Docker Image') {
                steps {

                    withCredentials([
                        usernamePassword(
                            credentialsId: 'dockerhub-creds',
                            usernameVariable: 'DOCKER_USER',
                            passwordVariable: 'DOCKER_PASS'
                        )
                    ]) {

                        sh """
                        echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin

                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                        docker push ${IMAGE_NAME}:latest
                        """

                    }
                }
            }

        }
    }