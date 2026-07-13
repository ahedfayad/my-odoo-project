#!/usr/bin/env groovy

pipeline {
    agent any

    environment {
        REGISTRY   = "quay.test.com:8443"
        REPOSITORY = "init/odoo"
        IMAGE_NAME = "odoo"
    }

    stages {

        stage('Show Jenkins Information') {
            steps {
                echo "Build Number : ${env.BUILD_NUMBER}"
                echo "Git Commit   : ${env.GIT_COMMIT}"
            }
        }

        stage('Get Git Tag') {
            steps {
                script {
                    env.IMAGE_TAG = sh(
                        script: 'git describe --tags --exact-match',
                        returnStdout: true
                    ).trim()

                    echo "Image Tag: ${env.IMAGE_TAG}"
                }
            }
        }

        stage('Build Image') {
            steps {
                sh """
                    docker build \
                        -t ${IMAGE_NAME}:${IMAGE_TAG} .

                    docker tag \
                        ${IMAGE_NAME}:${IMAGE_TAG} \
                        ${REGISTRY}/${REPOSITORY}/${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }

        stage('Push Image') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'quay-registry-creds',
                        usernameVariable: 'QUAY_USER',
                        passwordVariable: 'QUAY_PASS'
                    )
                ]) {

                    sh """
                        echo "\$QUAY_PASS" | docker login ${REGISTRY} \
                            -u "\$QUAY_USER" --password-stdin

                        docker push ${REGISTRY}/${REPOSITORY}/${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }
    }
    post {
        success {
            echo "Image successfully pushed."
        }
    failure {
        echo "Something failed."
        }
    always {
        cleanWs()
        }
    }

}
