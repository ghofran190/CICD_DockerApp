pipeline {
    agent { label 'windows-agent' }
    environment {
        IMAGE_NAME = "ghofrane13/demo-helloworld"
        DOCKERHUB_CREDENTIALS = "dockerhub-creds"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']],
                          userRemoteConfigs: [[url: 'https://github.com/ghofran190/CICD_DockerApp.git']]])
            }
        }

        stage('Build with Maven') {
            steps {
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    IMAGE_TAG = "${env.BUILD_NUMBER}"
                }
                bat "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                bat "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest"
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: DOCKERHUB_CREDENTIALS,
                                                 usernameVariable: 'DOCKER_USER',
                                                 passwordVariable: 'DOCKER_PASS')]) {
                    bat 'echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin'
                    bat "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                    bat "docker push ${IMAGE_NAME}:latest"
                }
            }
        }
    }

    stage('Deploy to Kubernetes') {
        steps {
            script {
                // Assurer que le namespace existe
                bat "kubectl create namespace ${KUBE_NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -"
                
                // Appliquer les fichiers YAML
                bat "kubectl apply -f deployment.yaml -n ${KUBE_NAMESPACE}"
                bat "kubectl apply -f service.yaml -n ${KUBE_NAMESPACE}"
                
                // Vérifier le déploiement
                bat "kubectl rollout status deployment/demo-helloworld -n ${KUBE_NAMESPACE} --timeout=300s"
                
                // Vérification supplémentaire
                bat "kubectl get pods -n ${KUBE_NAMESPACE}"
                bat "kubectl get services -n ${KUBE_NAMESPACE}"
            }
        }
    }


    post {
        success {
            echo "Pipeline terminé avec succès. Image : ${IMAGE_NAME}:${IMAGE_TAG}"
        }
        failure {
            echo "Échec du pipeline."
        }
    }
}
