pipeline {
    agent {
        label 'docker'
    }

    environment {
        PROJECT_NAME = "${env.JOB_NAME}-${env.BUILD_ID}"
    }

    options {
        buildDiscarder(logRotator(numToKeepStr:'10'))
        disableConcurrentBuilds()
    }

    stages {
        stage("Checkout") {
            agent {
                label 'master'
            }
            steps {
                checkout scm
                sh 'git submodule update --init'
                stash(name:'scripts', includes:'**')
            }
        }
        stage('Build') {
            steps {
                timeout(time:1, unit:'MINUTES') {
                    sh "docker-compose -p ${PROJECT_NAME} up compile"
                }
            }
        }
        stage('Deploy') {
            steps {
                timeout(time:10, unit:'MINUTES') {
                    sh 'docker-compose -p ${PROJECT_NAME} up deploy'
                }
            }
        }
        stage('Tests') {
            steps {
                timeout(time:10, unit:'MINUTES') {
                    sh 'docker-compose -p ${PROJECT_NAME} up unittests'
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