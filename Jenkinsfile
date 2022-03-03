pipeline {
    agent any
    tools {
        maven 'Maven'
    }
    environment {
        CI = 'true'
    }
    stages {
        stage('Build') {
            steps {
                echo "build stage"
                sh 'mvn clean install'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Staging') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: '8e880e36-0037-40bd-a9d2-5e798fba209b', keyFileVariable: 'PRIVATE_KEY')]) {
                    //sh 'su ubuntu' not possible
                    //sh 'whoami' is jenkins
                    sh 'ssh ubuntu@18.116.65.199 rm -f demo-0.0.1-SNAPSHOT.jar' //force will avoid error msg if directory doesn't exist
                    //sh 'scp -r /var/lib/jenkins/workspace/ ubuntu@18.116.65.199:/home/ubuntu'
                    sh 'scp /var/lib/jenkins/workspace/spring-boot/target/demo-0.0.1-SNAPSHOT.jar ubuntu@18.116.65.199:/home/ubuntu'
                    sh 'ssh ubuntu@18.116.65.199 ansible-playbook deploy.yml'
                }
            }
        }
    }
}