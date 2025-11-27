pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'MySonarQube'
        SONARQUBE_SCANNER = 'Sonar-Scanner'

        IMAGE_NAME = 'loan-app-2401034-v2'
        IMAGE_TAG = 'latest'

        REGISTRY = 'nexus.imcc.com'
        NEXUS_REPO = 'docker-hosted'
    }

    stages {

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("${SONARQUBE_SERVER}") {
                    withCredentials([string(credentialsId: 'sonar-2401034', variable: 'SONAR_TOKEN')]) {
                        script {
                            def scannerHome = tool "${SONARQUBE_SCANNER}"
                            sh """
                                ${scannerHome}/bin/sonar-scanner \
                                -Dsonar.projectKey=LoanPrediction-2401034-V2 \
                                -Dsonar.projectName=LoanPrediction-2401034-V2 \
                                -Dsonar.sources=. \
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
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Docker Push to Nexus') {
            steps {
                sh """
                docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${REGISTRY}/${NEXUS_REPO}/${IMAGE_NAME}:${IMAGE_TAG}
                docker push ${REGISTRY}/${NEXUS_REPO}/${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }

        stage('Deploy to Kubernetes') {
            when {
                expression { fileExists("k8s/deployment.yaml") }
            }
            steps {
                sh """
                kubectl apply -f k8s/deployment.yaml
                kubectl apply -f k8s/service.yaml
                """
            }
        }
    }
}
