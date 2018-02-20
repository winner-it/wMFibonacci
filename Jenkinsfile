pipeline {
    agent any

    environment {
        PROJECT_NAME = "${env.JOB_NAME}-${env.BUILD_ID}"
    }

    options {
        buildDiscarder(logRotator(numToKeepStr:'10'))
        disableConcurrentBuilds()
    }

    stages {
        stage('Build') {
            steps {
                timeout(time:1, unit:'MINUTES') {
                    sh "docker-composer -p ${PROJECT_NAME} build"
                }
            }
        }
        stage('Deploy') {
            steps {
                timeout(time:10, unit:'MINUTES') {
                    sh 'docker-composer -p ${PROJECT_NAME} deploy'
                }
            }
        }
    }

    post {
        always {
            sh "docker-compose -p ${PROJECT_NAME} down -v || true"
        }
    }
}