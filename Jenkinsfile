pipeline {
    agent {
        label 'docker'
    }

    environment {
        PROJECT_NAME = "${env.JOB_NAME}-${env.BUILD_ID}"
        WORKSPACE = "/var/jenkins_home/workspace/wMFibonacci"
        REGISTRY = "registry.docker.tests:5000"
        IMAGE_NAME = "${env.JOB_NAME.toLowerCase()}"
        IMAGE_VERSION = "10.1-${env.BUILD_ID}"
        IMAGE_PREFIX = "softwareag"
    }

    options {
        buildDiscarder(logRotator(numToKeepStr:'10'))
        disableConcurrentBuilds()
    }

    stages {
        /*
        Use Advanced Sub-Module Behaviors in Jenkins
        stage("Checkout") {
            steps {
                checkout scm
                sh 'git submodule update --init'
                stash(name:'scripts', includes:'**')
            }
        }
        */
        stage('Prepare') {
            steps {
                timeout(time:5, unit:'MINUTES') {
                    sh "docker-compose -p ${PROJECT_NAME} up -d testserver"
                }
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
            post {
                always {
                    junit "report/*.xml"
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

    post {
        always {
            sh "docker-compose -p ${PROJECT_NAME} down -v || true"
        }
    }
}