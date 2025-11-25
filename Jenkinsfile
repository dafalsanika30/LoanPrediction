pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'MySonarQube'          // the name you gave in Jenkins
        SONARQUBE_SCANNER = 'Sonar-Scanner'       // the tool name in Tools
        IMAGE_NAME = 'loan-app'
        IMAGE_TAG = 'latest'
        // For Nexus later, you can change REGISTRY + REPO
        REGISTRY = 'localhost:8081'
        NEXUS_REPO = 'docker-hosted'
    }

    stages {

        

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
                         -Dsonar.python.version=3.10 \
                         -Dsonar.sourceEncoding=UTF-8 \
                         -Dsonar.login=$SONAR_TOKEN
                    """
                }
            }
        }
    }
}


        // stage('Quality Gate') {
        //     steps {
        //         script {
        //             timeout(time: 3, unit: 'MINUTES') {
        //                 waitForQualityGate abortPipeline: true
        //             }
        //         }
        //     }
        // }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        // OPTIONAL – only when Nexus Docker repo is ready
        stage('Docker Push to Nexus') {
            when {
                expression { return false }  // set to true after Nexus Docker repo is configured
            }
            steps {
                sh """
                   docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${REGISTRY}/repository/${NEXUS_REPO}/${IMAGE_NAME}:${IMAGE_TAG}
                   docker push ${REGISTRY}/repository/${NEXUS_REPO}/${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }

        // OPTIONAL – only when Kubernetes cluster is available
        stage('Deploy to Kubernetes') {
            when {
                expression { return false }  // set to true when you connect Jenkins to k8s
            }
            steps {
                sh "kubectl apply -f k8s/deployment.yaml"
                sh "kubectl apply -f k8s/service.yaml"
            }
        }
    }
}
