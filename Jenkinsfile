pipeline {
    agent any
    
/*
     parameters {
        string(
            name: 'IMAGE_TAG',
            defaultValue: 'v1',
            description: 'Docker image tag'
        )
    }
*/


    stages {
        stage('Show Git Commit') {
            steps {
                echo "Git Commit: ${env.GIT_COMMIT}"
            }
        }

        stage('Show Build Number') {
            steps {
                echo "Current build number is: ${env.BUILD_NUMBER}"
            }
        }
        stage('build') {
            steps {
                sh """
                docker build  -t odoo:${env.GIT_COMMIT} .
                docker tag odoo:${env.GIT_COMMIT}  quay.test.com:8443/init/odoo/odoo:${env.GIT_COMMIT}
                """                                          
            }    
        }
        stage('push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'quay-registry-creds', 
                                                 usernameVariable: 'QUAY_USER',  
                                                 passwordVariable: 'QUAY_PASS')]) {
                                                     
                    sh 'echo $QUAY_PASS | docker login quay.test.com:8443 -u $QUAY_USER --password-stdin'
                    sh "docker push quay.test.com:8443/init/odoo/odoo:${env.GIT_COMMIT}"
                } // <--- FIXED: Closes the withCredentials block
            } // Closes the steps block
        } // Closes the stage block
    } // Closes the stages block
} // Closes the pipeline block


