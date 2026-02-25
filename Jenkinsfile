pipeline {
    agent { label 'agent-deploy' } 

    environment {
        DOCKER_USER = 'dvnpn'
        IMAGE_NAME  = 'simple-api'
        AWS_IP      = '54.82.5.212'
    }

    stages {
        stage('Build & Push API') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', 
                                 passwordVariable: 'DOCKER_PASS', 
                                 usernameVariable: 'DOCKER_USER_ID')]) {
                    
                    sh 'echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER_ID} --password-stdin'

                    // On crée un builder qui supporte le multi-plateforme, puis on build                  
                    sh """
                        docker buildx create --use --name mybuilder || true
                        docker buildx build --platform linux/amd64 -t ${DOCKER_USER}/${IMAGE_NAME}:latest --push .
                    """
                    
                    // Push
                    sh "docker push ${DOCKER_USER}/${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Deploy API to AWS') {
            steps {
                sshagent(credentials: ['aws-ssh-key']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ubuntu@${AWS_IP} "
                        sudo docker pull ${DOCKER_USER}/${IMAGE_NAME}:latest
                        
                        sudo docker stop ${IMAGE_NAME} || true
                        sudo docker rm ${IMAGE_NAME} || true
                        
                        # On expose le port 3000 pour l'API
                        sudo docker run -d --name ${IMAGE_NAME} -p 3000:3000 ${DOCKER_USER}/${IMAGE_NAME}:latest
                    "
                    """
                }
            }
        }
    }
}