pipeline {
    agent any

    environment {
        // ---- SonarQube ----
        SONARQUBE_SERVER  = 'MySonarQube'      // must match name in Jenkins "Configure System"
        SONARQUBE_SCANNER = 'Sonar-Scanner'    // must match tool name in Jenkins "Global Tool Config"

        // ---- Docker / Nexus ----
        IMAGE_NAME = 'loan-app'
        IMAGE_TAG  = 'latest'

        // Example: if your Docker hosted repo URL is nexus.imcc.com:8083
        // ask your sir what exact URL/port to use and update this:
        REGISTRY   = 'nexus.imcc.com:8083'
        NEXUS_REPO = 'docker-hosted'           // Docker hosted repo name in Nexus

        // ---- Kubernetes ----
        K8S_NAMESPACE = 'loanprediction'       // or "default" if they didn't give namespace
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("${SONARQUBE_SERVER}") {
                    withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                        script {
                            def scannerHome = tool "${SONARQUBE_SCANNER}"
                            sh """
                                ${scannerHome}/bin/sonar-scanner \
                                  -Dsonar.projectKey=LoanPrediction \
                                  -Dsonar.projectName=LoanPrediction \
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

        stage('Docker Push to Nexus') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'nexus-docker-creds',
                        usernameVariable: 'NEXUS_USER',
                        passwordVariable: 'NEXUS_PASS'
                    )
                ]) {
                    sh """
                        echo "$NEXUS_PASS" | docker login ${REGISTRY} -u "$NEXUS_USER" --password-stdin
                        docker push ${REGISTRY}/${NEXUS_REPO}/${IMAGE_NAME}:${IMAGE_TAG}
                        docker logout ${REGISTRY}
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            when {
                expression { fileExists('k8s/deployment.yaml') }
            }
            steps {
                sh """
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                    # Try namespaced first, then default
                    kubectl rollout status deployment/loan-deployment -n ${K8S_NAMESPACE} || \
                    kubectl rollout status deployment/loan-deployment
                """
            }
        }
    }
}
