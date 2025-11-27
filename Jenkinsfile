pipeline {
    agent any

    environment {
        IMAGE_NAME = 'loan-app-2401034-v2'
        IMAGE_TAG = 'latest'

        REGISTRY = 'nexus.imcc.com'
        NEXUS_REPO = 'docker-hosted'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        // ---- Sonar Removed because Kubernetes agent has low memory ----

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
