pipeline {
    agent any
    environment {
        IMAGE_NAME = "ghofrane13/demo-helloworld"
        DOCKERHUB_CREDENTIALS = "dockerhub-creds" // ID des credentials Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/ghofran190/CICD_DockerApp.git'
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
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest"
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: env.DOCKERHUB_CREDENTIALS,
                                                 usernameVariable: 'DOCKER_USER',
                                                 passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker push ${IMAGE_NAME}:latest"
                }
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
