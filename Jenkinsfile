pipeline {
    agent any

    environment {
        SONARQUBE_SERVER  = 'MySonarQube'
        SONARQUBE_SCANNER = 'Sonar-Scanner'

        ROLL = '2401034'

        IMAGE_NAME = "loan-app-${ROLL}"
        IMAGE_TAG  = 'latest'

        REGISTRY   = 'nexus.imcc.com:8083'
        NEXUS_REPO = 'docker-hosted'

        K8S_NAMESPACE = "student-${ROLL}"
        DEPLOYMENT_NAME = "loan-deploy-${ROLL}"
        SERVICE_NAME    = "loan-svc-${ROLL}"
    }

    stages {

        stage('Checkout') {
            steps { checkout scm }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("${SONARQUBE_SERVER}") {
                    withCredentials([string(credentialsId: 'sonar-token-2401034', variable: 'SONAR_TOKEN')]) {
                        script {
                            def scannerHome = tool "${SONARQUBE_SCANNER}"
                            sh """
                                ${scannerHome}/bin/sonar-scanner \
                                  -Dsonar.projectKey=LoanPrediction-${ROLL} \
                                  -Dsonar.projectName=LoanPrediction-${ROLL} \
                                  -Dsonar.sources=. \
                                  -Dsonar.sourceEncoding=UTF-8 \
                                  -Dsonar.python.version=3.10 \
                                  -Dsonar.host.url=http://sonarqube.imcc.com \
                                  -Dsonar.login=$SONAR_TOKEN
                            """
                        }
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    timeout(time: 5, unit: 'MINUTES') {
                        waitForQualityGate abortPipeline: true
                    }
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh """
                docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${REGISTRY}/${NEXUS_REPO}/${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }

        stage('Push to Nexus') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'nexus-docker-creds', usernameVariable: 'NUSER', passwordVariable: 'NPASS')]) {
                    sh """
                    echo "$NPASS" | docker login ${REGISTRY} -u "$NUSER" --password-stdin
                    docker push ${REGISTRY}/${NEXUS_REPO}/${IMAGE_NAME}:${IMAGE_TAG}
                    docker logout ${REGISTRY}
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                kubectl create namespace ${K8S_NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -
                kubectl apply -f k8s/
                kubectl rollout status deployment/${DEPLOYMENT_NAME} -n ${K8S_NAMESPACE}
                """
            }
        }
    }
}
