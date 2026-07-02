pipeline {
    agent any
    stages {
        stage('build') {
            steps {
                sh '''
                docker build  -t odoo:v1 .
                docker tag odoo:v1 quay.test.com:8443/init/odoo/odoo:v1
                '''                          
            }    
        }
        stage('push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'quay-registry-creds', 
                                 usernameVariable: 'QUAY_USER',  // You can call this nickname anything you want!
                                 passwordVariable: 'QUAY_PASS')]) {
                                    sh 'echo $QUAY_PASS | docker login quay.test.com:8443 -u $QUAY_USER --password-stdin'
                                    sh 'docker push quay.test.com:8443/init/odoo/odoo:v1'

            }
        }

    }
    
}
