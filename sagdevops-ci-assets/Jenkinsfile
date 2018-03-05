pipeline {
    agent none

    environment {
        PROJECT_NAME = "${env.JOB_NAME}-${env.BUILD_ID}"
        REGISTRY = "registry.docker.tests:5000"
        IMAGE_NAME = "${env.JOB_NAME.toLowerCase()}-builder"
        IMAGE_VERSION = "${env.BUILD_ID}"
        IMAGE_PREFIX = "softwareag"
    }

    stages {
        stage('Tests') {
            agent {
                docker { image 'inikolaev/alpine-jdk-ant' }
            }

            steps {
                script {
                    sh "ant -DPROJECT_NAME=${PROJECT_NAME} unitTests"
                }
            }
        }

        stage('Save2Docker') {
            steps {
                echo 'Saving Docker image'
                script {
                    docker.withRegistry('https://${REGISTRY}') {
                        def customImage = docker.build("${IMAGE_PREFIX}/${IMAGE_NAME}:${IMAGE_VERSION}")
                        customImage.push()
                        customImage.push("latest")
                    }
                }
            }
        }
    }
}