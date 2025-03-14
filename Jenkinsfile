pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID = "533267023710"
        AWS_REGION = "us-east-1"
        REPO_URL = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/portfolio-website-repo"
        IMAGE_TAG = "latest"
        IMAGE_NAME = "my-portfolio-web"
    }
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image using the Dockerfile in your local folder
                    dockerImage = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                    echo "Docker Image built: ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
        stage('Login to AWS ECR') {
            steps {
                script {
                    // Use Jenkins credentials to authenticate AWS CLI to AWS ECR
                    withCredentials([usernamePassword(credentialsId: 'AWS_CREDENTIALS', 
                                                      usernameVariable: 'AWS_ACCESS_KEY_ID', 
                                                      passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        // Configure AWS CLI for Jenkins job
                        sh '''
                        aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}
                        aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}
                        aws configure set default.region ${AWS_REGION}
                        '''

                        // Authenticate Docker to AWS ECR
                        sh '''
                        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 533267023710.dkr.ecr.us-east-1.amazonaws.com/portfolio-website-repo
                        '''
                    }
                }
            }
        }
        stage('Tag Docker Image') {
            steps {
                script {
                    // Log the current Docker image and the target ECR repository
                    echo "Tagging Docker image ${IMAGE_NAME}:${IMAGE_TAG} as ${REPO_URL}:${IMAGE_TAG}"
                    
                    // Correctly tag the Docker image for ECR
                    sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${REPO_URL}:${IMAGE_TAG}"
                    
                    echo "Docker image tagged successfully."
                }
            }
        }
        stage('Push Docker Image to ECR') {
            steps {
                script {
                    // Push the Docker image to ECR
                    sh "docker push ${REPO_URL}:${IMAGE_TAG}"
                    
                    echo "Docker image pushed to ECR: ${REPO_URL}:${IMAGE_TAG}"
                }
            }
        }
    }
    post {
        success {
            echo 'Docker Image has been successfully pushed to AWS ECR!'
        }
        failure {
            echo 'The pipeline failed.'
        }
    }
}
