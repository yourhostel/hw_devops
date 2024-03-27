# Step project 2!

Task:
1. Create test GitLab repo with react app from `lection_scripts/lesson-20240215`, edit test script command to exit after tests execution
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


## Edit test script command to exit after tests execution
![first (1).jpg](screenshots%2Ffirst%20%281%29.jpg)
![first (2).jpg](screenshots%2Ffirst%20%282%29.jpg)
## Create test account in Docker hub.
## Create two VMs
## In Vagrant file add installation of docker, docker-compose on first VM
![first (3).jpg](screenshots%2Ffirst%20%283%29.jpg)
![first (4).jpg](screenshots%2Ffirst%20%284%29.jpg)
![first (5).jpg](screenshots%2Ffirst%20%285%29.jpg)