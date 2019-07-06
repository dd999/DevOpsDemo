#!/bin/groovy

def dockerImg

pipeline {
    environment {
    registry = "dd999/myapp"
    registryCredential = 'dockerhub'
    dockerImage = ''
  }
    agent {
        label 'master'
    }
    
    stages {
        stage ('Clone Repo') {
            steps {
                /* Clone git Repository */
                checkout scm
            }
        }

        stage ('Test Package') {
            steps {
                /* test application using maven */
                sh 'mvn test'
            }
            post {
                always {
                    /* Perform JUnit testing
                    * sh './gradlew check' */
                    archiveArtifacts "target/**/*"
                    junit '**/target/*-reports/*.xml'
                }
            }
        }

        stage ('Compile & Package') {
            steps {
                /* Package Application using maven */
                sh 'mvn package'
            }
        }

        stage ('SonaQube Analysis') {
            steps {
                /* Static code analysis with SonarQube */
                withSonarQubeEnv('sonarqube') {
                    sh 'mvn sonar:sonar'
                }
            }
        }

        stage ('Build Image') {
            steps {
                echo "Build docker image"
                script {
                    /* This builds the actual image; synonymous to
                    * docker build on the command line */
                    /*dir('ci_helper){
                        sh 'sudo docker build -t dd999/myapp:${env.BUILD_NUMBER} .'
                        withCredentials([userPass(credentialsId: 'docker-hub-credentials',passwordVariabl 
                        sh 'docker run --name myapp -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock dd999/myapp'*/
                    /*dockerImage = docker.build registry + ":$BUILD_NUMBER"*/
                    sh "sudo chown $USER:docker ~/.docker"
                    sh "sudo chown $USER:docker ~/.docker/config.json"
                    sh 'sudo chmod g+rw ~/.docker/config.json'
                    sh "sudo usermod -a -G docker $USER"
                   /* sh 'sudo snap connect docker:home'*/
                    /*sh 'sudo chown jenkins:jenkins /root/.docker -R'*/
                    dockerImg = docker.build("dd999/myapp")
                }
            }
        }

        stage ('Push Image') {
            steps {
                echo "Push Image on DockerHub"
                script {
                    /* Finally, we'll push the image with two tags:
                    * First, the incremental build number from Jenkins
                    * Second, the 'latest' tag. */
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
                        dockerImg.push("${env.BUILD_NUMBER}")
                        dockerImg.push("latest")
                    }
                }
            }
        }
         stage ('Deploy'){
               sh "sudo docker run -itd --name container-$BUILD_NUMBER -p 8080:8082 dd999/myapp:${env.BUILD_NUMBER}"
           }
    }
 
        /*stage ('Selenium Tests')
            steps {
                echo "Selenium tests"
                script { 
                    sh 'mvn failsafe:integration-test -Dskip.surefire.tests -Dapp.url=http://localhost:8080/'
                }
            }*/
                
       
    post {
        success {
            echo "Send success email notification"
            mail bcc: '', body: " Build Status : Success <br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br>Build URL: ${env.BUILD_URL} <br>App URL: http://34.93.124.155/addressbook", cc: '', charset: 'UTF-8',  mimeType: 'text/html', replyTo: '', subject: "Jenkins Build Status -> ${env.JOB_NAME}", to: "shimmersonal@gmail.com";
        }
        failure {
            echo "send failure email notification"
            mail bcc: '', body: " Build Status : Failed <br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br>Build URL: ${env.BUILD_URL}", cc: '', charset: 'UTF-8',  mimeType: 'text/html', replyTo: '', subject: "Jenkins Build Status -> ${env.JOB_NAME}", to: "shimmersonal@gmail.com";
        }
    }
}
