# Step project 2!

Task:
1. Create test GitLab repo with react app from [lection_scripts/lesson-20240215/react](https://gitlab.com/dan-it/groups/devops2/lection_scripts/-/tree/main/lesson-20240215/react?ref_type=heads), edit test script command to exit after tests execution
2. Create test account in Docker hub(free): https://hub.docker.com/
3. Use Vagrant or other IaC option to create two VMs: one for Jenkins server and second for Jenkins worker
4. Manually or in Vagrant file add installation of docker, docker-compose on first VM
5. Manually or using Vagrant file add installation of docker, Jenkins worker directly on the second VM(without docker)
6. Connect Jenkins worker to master node. Check that you can run test pipeline on Jenkins worker
7. Add credentials with your Docker hub user and password to Jenkins credentials.
8. Create test pipeline using groovy language, which will start when you push to the repo from the step 1 (check changes by cron or webhook notification if you have public IP for jenkins server).  
  Pipeline must pull code, install dependencies, run tests, build docker image on Jenkins worker.  
  If tests are successfull, then login to your Docker hub account using Jenkins credentials from the step 7 and push built image to Docker hub.  
  If tests fail, just print message "Tests failed"

- The vagrant is controlled using the [script "v"](https://github.com/yourhostel/hw_devops/blob/main/step_project_2/v) 
- examples :
  l: launch, s: stop, d: destroy, r: reload, p: provision, c: clear index
  - `bash v l`     the same as 
```bash
vagrant up && \
vagrant ssh jenkins_master -c "bash /vagrant/vagrant_scripts/add_worker_key_to_container.sh jenkins"
```
  - `bash v l p`   the same as 
```bash
vagrant up --provision && \
vagrant ssh jenkins_master -c "bash /vagrant/vagrant_scripts/add_worker_key_to_container.sh jenkins"
```
  - `bash v l p c` the same as 
```bash
rm -f ~/.vagrant.d/data/machine-index/index && \
vagrant up --provision && \
vagrant ssh jenkins_master -c "bash /vagrant/vagrant_scripts/add_worker_key_to_container.sh jenkins" 
```
  - `bash v s` the same as 
```bash
vagrant halt
```
  - `bash v d` the same as 
```bash
vagrant destroy -f
```
  - `bash v r` the same as 
```bash
vagrant vagrant reload && \
vagrant ssh jenkins_master -c "bash /vagrant/vagrant_scripts/add_worker_key_to_container.sh jenkins"
```

## Edit test script command to exit after tests execution
![first (1).jpg](screenshots%2Ffirst%20%281%29.jpg)
![first (2).jpg](screenshots%2Ffirst%20%282%29.jpg)
## Create test account in Docker hub.
## Create two VMs
## In Vagrant file add installation of docker, docker-compose on first VM
![first (3).jpg](screenshots%2Ffirst%20%283%29.jpg)
![first (4).jpg](screenshots%2Ffirst%20%284%29.jpg)
![first (5).jpg](screenshots%2Ffirst%20%285%29.jpg)
## Add credentials with your Docker hub user and password to Jenkins credentials.

```groovy
pipeline {
    agent {
        node {     
          label 'JDK17'
        }  
    }
    
    environment {
        // Generating a tag in the format 'YYYYMMDD-HHMMSS'
        DOCKER_TAG = "${new java.text.SimpleDateFormat('yyyyMMdd-HHmmss').format(new Date())}"
        IMAGE_NAME = "yourhostel/my-react-app"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm: [ 
                  $class: 'GitSCM', 
                  branches: [[name: '*/main']], 
                  userRemoteConfigs: [
                    [url: 'git@github.com:yourhostel/hw_devops.git',
                     credentialsId: 'yourhostel']
                  ]
                ]
            }
        }

        stage('Build') {
            steps {
                dir('step_project_2/react') {
                sh 'npm install'
                sh 'npm run build'
                } 
            }
        }
        
        stage('Test') {
            steps {
                dir('step_project_2/react') {
                sh 'npm test'
                } 
            }
        }
        
        stage('Build Docker Image') {
            steps {
                dir('step_project_2/react') {
                    script {
                        // Build the Docker image
                        sh "docker build -t ${env.IMAGE_NAME}:${env.DOCKER_TAG} ."
                    }
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    // Login to Docker Hub and upload an image
                    withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                        sh "docker push ${env.IMAGE_NAME}:${env.DOCKER_TAG}"
                    }
                }
            }
        }
    }
}
```
![second (1).jpg](screenshots%2Fsecond%20%281%29.jpg)
- [my-react-app is on hub.docker.com](https://hub.docker.com/repository/docker/yourhostel/my-react-app/general) 
 
![second (2).jpg](screenshots%2Fsecond%20%282%29.jpg)

## Worker demonstration
![third (1).jpg](screenshots%2Fthird%20%281%29.jpg)
![third (2).jpg](screenshots%2Fthird%20%282%29.jpg)