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
                sh 'mvn test'
            }
        }/*
        stage('Test') {
            steps {
                sh 'mvn test'
        }
        stage('Deliver') {
            steps {
                sh 'scp 'g
            }
        }*/
    }
}