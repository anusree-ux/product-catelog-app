pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
    - name: dind
      image: docker:24-dind
      securityContext:
        privileged: true
      env:
        - name: DOCKER_TLS_CERTDIR
          value: ""
      volumeMounts:
        - name: docker-storage
          mountPath: /var/lib/docker

    - name: docker
      image: docker:24-cli
      command: ['cat']
      tty: true
      env:
        - name: DOCKER_HOST
          value: tcp://localhost:2375

    - name: kubectl
      image: alpine/k8s:1.30.2
      command: ['cat']
      tty: true

  volumes:
    - name: docker-storage
      emptyDir: {}
'''
        }
    }

    environment {
        BACKEND_IMAGE = "anusree15/product-backend"
        FRONTEND_IMAGE = "anusree15/product-frontend"
        NAMESPACE = "product-catalog"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Wait for Docker Daemon') {
            steps {
                container('docker') {
                    sh '''
                        for i in $(seq 1 30); do
                          if docker info >/dev/null 2>&1; then
                            echo "Docker daemon is ready."
                            exit 0
                          fi

                          echo "Waiting for Docker daemon... ($i/30)"
                          sleep 2
                        done

                        echo "Docker daemon failed to start."
                        exit 1
                    '''
                }
            }
        }

        stage('Build Backend Image') {
            steps {
                container('docker') {
                    sh """
                        docker build \
                          -t ${BACKEND_IMAGE}:${BUILD_NUMBER} \
                          -t ${BACKEND_IMAGE}:latest \
                          ./backend
                    """
                }
            }
        }

        stage('Build Frontend Image') {
            steps {
                container('docker') {
                    sh """
                        docker build \
                          -t ${FRONTEND_IMAGE}:${BUILD_NUMBER} \
                          -t ${FRONTEND_IMAGE}:latest \
                          ./frontend
                    """
                }
            }
        }

        stage('Push Images') {
            steps {
                container('docker') {
                    withCredentials([
                        usernamePassword(
                            credentialsId: 'dockerhub-creds',
                            usernameVariable: 'DOCKERHUB_USER',
                            passwordVariable: 'DOCKERHUB_TOKEN'
                        )
                    ]) {

                        sh """
                            echo "\$DOCKERHUB_TOKEN" | docker login -u "\$DOCKERHUB_USER" --password-stdin

                            docker push ${BACKEND_IMAGE}:${BUILD_NUMBER}
                            docker push ${BACKEND_IMAGE}:latest

                            docker push ${FRONTEND_IMAGE}:${BUILD_NUMBER}
                            docker push ${FRONTEND_IMAGE}:latest
                        """
                    }
                }
            }
        }

        stage('Validate Kubernetes Manifests') {
            steps {
                container('kubectl') {
                    sh '''
                        kubectl apply --dry-run=client -k k8s/base
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                container('kubectl') {

                    sh """
                        kubectl set image deployment/backend \
                        backend=${BACKEND_IMAGE}:${BUILD_NUMBER} \
                        -n ${NAMESPACE}

                        kubectl set image deployment/frontend \
                        frontend=${FRONTEND_IMAGE}:${BUILD_NUMBER} \
                        -n ${NAMESPACE}
                    """
                }
            }
        }

        stage('Wait for Rollout') {
            steps {
                container('kubectl') {
                    sh """
                        kubectl rollout status deployment/backend -n ${NAMESPACE} --timeout=300s

                        kubectl rollout status deployment/frontend -n ${NAMESPACE} --timeout=300s
                    """
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                container('kubectl') {
                    sh """
                        kubectl get pods -n ${NAMESPACE}

                        kubectl get deployments -n ${NAMESPACE}

                        kubectl get services -n ${NAMESPACE}
                    """
                }
            }
        }
    }

    post {

        success {
            echo """
=========================================
CI/CD Pipeline Completed Successfully
=========================================

Backend Image:
${BACKEND_IMAGE}:${BUILD_NUMBER}

Frontend Image:
${FRONTEND_IMAGE}:${BUILD_NUMBER}

Application deployed successfully.
"""
        }

        failure {
            echo """
=========================================
Pipeline Failed
=========================================

Check the failed stage in Jenkins logs.
"""
        }
    }
}
