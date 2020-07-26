pipeline {
    //this should be given by jenkins at build time
    environment {
        PROJECT_NAME = "${env.JOB_NAME}"
        
        BUILD_NAME = "${PROJECT_NAME}"
        BUILD_VERSION = "0.0.${env.BUILD_ID}"
        BUILD_PROFILE = "prod"
        BUILD_FINAL = "${BUILD_NAME}-${BUILD_VERSION}".toLowerCase()
        PACKAGE_S3_BUCKET_REGION = "us-east-1"
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

                fileOperations(
                    [
                    	folderCopyOperation(sourceFolderPath: "./target/${PROJECT_NAME}/build/", destinationFolderPath: "./packaging/${BUILD_FINAL}/"),
                        fileZipOperation(folderPath: "./packaging/${BUILD_FINAL}/", outputFolderPath: "./packaging/"),
                        folderDeleteOperation("./packaging/${BUILD_FINAL}/")
                    ]
                )
            }
        }
        
        stage('Deploy') {
            steps {
				sh "${env.SAG_HOME}/common/lib/ant/bin/ant -DSAGHome=${env.SAG_HOME} -DSAG_CI_HOME=${env.SAG_CI_HOME} -DprojectName=${PROJECT_NAME} deploy"
            }
        }
        
	 	stage('Test') {
	        steps {
				sh "${env.SAG_HOME}/common/lib/ant/bin/ant -DSAGHome=${env.SAG_HOME} -DSAG_CI_HOME=${env.SAG_CI_HOME} -DprojectName=${PROJECT_NAME} test"
				junit 'report/'
	        }
	    }
    }
        
    post {
        success {
        	echo "success...final tasks..."
        	
            echo "Upload good build to s3"
            withAWS(region:"${PACKAGE_S3_BUCKET_REGION}") {
                s3Upload(
                    file:"./packaging/${BUILD_FINAL}.zip", 
                    bucket:"${PACKAGE_S3_BUCKET}", 
                    path:"${PACKAGE_S3_BUCKET_PREFIX}/${BUILD_FINAL}.zip",
                    pathStyleAccessEnabled: true, 
                    payloadSigningEnabled: true,
                )
            }
            
            echo "Cleaning up"
            //fileOperations(
            //    [
            //        fileDeleteOperation(excludes: "", includes: "./packaging/${BUILD_FINAL}.zip")
            //    ]
            //)
        }
    }
}