pipeline {
    //this should be given by jenkins at build time
    environment {
        PROJECT_NAME = "${env.JOB_NAME}-${env.BUILD_ID}"
        BUILD_NAME = "${env.JOB_NAME}".toLowerCase()
        BUILD_VERSION = "0.0.${env.BUILD_ID}"
        BUILD_PROFILE = "prod"
        BUILD_FINAL = "${BUILD_NAME}-${BUILD_PROFILE}-${BUILD_VERSION}"
        PACKAGE_S3_BUCKET = "sedemos-prod-main"
        PACKAGE_S3_BUCKET_PREFIX = "cicd_builds/wxFiboncci"
    }

    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr:'10'))
        disableConcurrentBuilds()
    }

    stages {
        stage('Build') {
            steps {
                echo "Building code with profile ${NPM_BUILD_PROFILE}"
            }
        }
        stage('Package') {
            steps {
                echo "Packaging build - ${BUILD_FINAL}"
            }
        }
    }

    post {
        success {
            echo "Upload build to s3"
            
            echo "Cleaning up"
        }
    }
}