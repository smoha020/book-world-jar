pipeline {
    agent any
    tools {
        maven 'Maven'
    }
    environment {
        CI = 'true'
    }
    stages {
        /*stage('Build') {
            steps {
                echo "build stage"
                sh 'mvn clean install'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }*/
        stage('Staging') {
            steps {
                sh 'scp var/lib/jenkins/workspace/spring-boot/target/demo-0.0.1-SNAPSHOT.jar ubuntu@18.116.65.199:/home/ubuntu'
            }
        }
    }
}