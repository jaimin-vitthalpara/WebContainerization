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
                        aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${REPO_URL}
                        '''
                    }
                }
            }
        }
        stage('Tag and Push Docker Image to ECR') {
            steps {
                script {
                    // Correctly tag the Docker image for ECR
                    dockerImage.tag("${REPO_URL}:${IMAGE_TAG}")
                    
                    // Push the Docker image to ECR
                    dockerImage.push("${REPO_URL}:${IMAGE_TAG}")
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
