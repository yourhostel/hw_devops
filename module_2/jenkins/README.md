# Building and testing the "[Cards Simple Backend](https://github.com/yourhostel/cards_simple_backend-)"

The pipeline runs on a specially configured [jenkins agent](https://github.com/yourhostel/hw_devops/blob/main/module_2/jenkins/Dockerfile.agent)
![2024-03-16_031704.jpg](img%2F2024-03-16_031704.jpg)

### jenkins-agent Labels JDK21
![2024-03-16_032521.jpg](img%2F2024-03-16_032521.jpg)

```groovy
pipeline {
    agent {
        node {     
          label 'JDK21'
        }  
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm: [ 
                  $class: 'GitSCM', 
                  branches: [[name: '*/main']], 
                  userRemoteConfigs: [
                    [url: 'https://github.com/yourhostel/cards_simple_backend-.git',
                     credentialsId: 'e4922dee-52ca-4194-bdcb-41415546bdaf']
                  ]
                ]
            }
        }

        stage('Build') {
            steps {
                // build Maven
                sh 'mvn clean install'
            }
        }

         stage('Tests') {
            parallel {
                stage('VisitTest') {
                    steps {
                        sh 'mvn -Dtest=VisitTest test'
                    }
                }
                stage('VisitCardiologistTest') {
                    steps {
                        sh 'mvn -Dtest=VisitCardiologistTest test'
                    }
                }
                stage('VisitDentistTest') {
                    steps {
                        sh 'mvn -Dtest=VisitDentistTest test'
                    }
                }
                stage('VisitTherapistTest') {
                    steps {
                        sh 'mvn -Dtest=VisitTherapistTest test'
                    }
                }
            }
        }
    }
}
```

### Build `mvn clean install` and run tests in parallel
- `mvn -Dtest=VisitTest test`
- `mvn -Dtest=VisitCardiologistTest test`
- `mvn -Dtest=VisitDentistTest test`
- `mvn -Dtest=VisitTherapistTest test`

![2024-03-16_030129.jpg](img%2F2024-03-16_030129.jpg)