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
                docker build  -t odoo:${env.BUILD_NUMBER} .
                docker tag odoo:${env.BUILD_NUMBER}  quay.test.com:8443/init/odoo/odoo:${env.BUILD_NUMBER}
                """                                          
            }    
        }
        stage('push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'quay-registry-creds', 
                                                 usernameVariable: 'QUAY_USER',  
                                                 passwordVariable: 'QUAY_PASS')]) {
                                                     
                    sh 'echo $QUAY_PASS | docker login quay.test.com:8443 -u $QUAY_USER --password-stdin'
                    sh "docker push quay.test.com:8443/init/odoo/odoo:${env.BUILD_NUMBER}"
                } // <--- FIXED: Closes the withCredentials block
            } // Closes the steps block
        } // Closes the stage block
    } // Closes the stages block
} // Closes the pipeline block


