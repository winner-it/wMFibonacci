pipeline {
    //this should be given by jenkins at build time
    environment {
        PROJECT_NAME = "${env.JOB_NAME}"
        
        BUILD_NAME = "${env.JOB_NAME}"
        BUILD_VERSION = "0.0.${env.BUILD_ID}"
        BUILD_PROFILE = "prod"
        BUILD_FINAL = "${BUILD_NAME}-${BUILD_PROFILE}-${BUILD_VERSION}".toLowerCase()
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
                echo "Building code for ${PROJECT_NAME} with profile ${BUILD_PROFILE}"
                timeout(time:1, unit:'MINUTES') {
                    sh "${env.SAG_HOME}/common/lib/ant/bin/ant -DSAGHome=${env.SAG_HOME} -DSAG_CI_HOME=${env.SAG_CI_HOME} -DprojectName=${PROJECT_NAME} build"
                }
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