# Step final

 [homework-step-final.md](https://gitlab.com/dan-it/groups/devops2/homework/-/blob/main/homework-step-final.md)

## Task 1 Create GitHub/GitLab repo with

* test python backend server. Just script which listening on some port and respond 200 on / 
* Dockerfile with everything needed to run this script
* GitHub actions or GitLab CI which will build docker image automatically and push to docker hub. Use Github secrets or Gitlab variables to store your docker hub creds

### Execution:
1. Created workflows in the root of the git repository [.github/workflows/main.yml](https://github.com/yourhostel/hw_devops/blob/main/.github/workflows/main.yml)
2. A trigger is set to run workflows in response to changes in the [project folder](https://github.com/yourhostel/hw_devops/tree/main/module_4/homework-step-final) only.
```yml
on:
  push:
    branches:
      - main
    paths:
      - 'module_4/homework-step-final/python/**'
```
3. Added [app.py](https://github.com/yourhostel/hw_devops/blob/main/module_4/homework-step-final/app.py) and [Dockerfile](https://github.com/yourhostel/hw_devops/blob/main/module_4/homework-step-final/Dockerfile) to the project.
4. Added repository secrets.
![final-1 (1).jpg](screenshots%2Ftask-1%2Ffinal-1%20%281%29.jpg)
5. Checking the workflows.
![final-1 (2).jpg](screenshots%2Ftask-1%2Ffinal-1%20%282%29.jpg)
![final-1 (3).jpg](screenshots%2Ftask-1%2Ffinal-1%20%283%29.jpg)
![final-1 (4).jpg](screenshots%2Ftask-1%2Ffinal-1%20%284%29.jpg)

## Write terraform code to create EKS cluster
* use code from lection_scripts/lesson-20240620/EKS
* one node group with one node
* nginx ingress controller
### Execution:
### Useful commands:
```bash
# LOCK_ID - this is the lock ID shown in the error message
terraform force-unlock LOCK_ID 
terraform state list
ps aux | grep terraform
```