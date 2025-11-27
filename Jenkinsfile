pipeline {
    agent {
        kubernetes {
            label "jenkins-agent-${env.BUILD_ID}"
            yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: jenkins-agent
spec:
  containers:
    - name: docker
      image: docker:dind
      command: ["dockerd-entrypoint.sh"]
      securityContext:
        privileged: true
      volumeMounts:
        - name: workspace-volume
          mountPath: /home/jenkins/agent
  volumes:
    - name: workspace-volume
      emptyDir: {}
"""
        }
    }

    environment {
        IMAGE_NAME = "loan-app-2401034-v2"
        IMAGE_TAG = "latest"
        REGISTRY = "nexus.imcc.com"
        NEXUS_REPO = "docker-hosted"
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

        stage('Docker Push') {
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
