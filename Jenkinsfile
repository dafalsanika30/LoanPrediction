podTemplate(containers: [
    containerTemplate(
        name: 'docker',
        image: 'docker:dind',
        ttyEnabled: true,
        command: 'dockerd-entrypoint.sh'
    )
]) {

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

        stage('Docker Build') {
            steps {
                container('docker') {
                    sh """
                    docker build -t ${REGISTRY}/${NEXUS_REPO}/${IMAGE_NAME}:${IMAGE_TAG} .
                    """
                }
            }
        }

        stage('Docker Push to Nexus') {
            steps {
                container('docker') {
                    sh """
                    docker push ${REGISTRY}/${NEXUS_REPO}/${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
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
}
