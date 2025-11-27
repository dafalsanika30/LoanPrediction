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
                                -Dsonar.token=$SONAR_TOKEN \
                                -Dsonar.scanner.forceBootstrap=true \
                                -Dsonar.python.version=3.10 \
                                -Dsonar.python.indexing.file.limit=5 \
                                -Dsonar.scanner.skipPlugins=true
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
                docker build -t ${REGISTRY}/${NEXUS_REPO}/${IMAGE_NAME}:${IMAGE_TAG} .
                """
            }
        }

        stage('Docker Push to Nexus') {
            steps {
                sh """
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
