# Homework AWS Lambda API GW

[homework-20240425-lambda-apigw](https://gitlab.com/dan-it/groups/devops2/homework/-/blob/main/homework-20240425-lambda-apigw.md)

1) Writing scripts([start_instances.py](https://github.com/yourhostel/hw_devops/blob/main/module_3/homework-lambda-apigw/start_instances.py), [stop_instances.py](https://github.com/yourhostel/hw_devops/blob/main/module_3/homework-lambda-apigw/stop_instances.py)) and adding to the archive.
```bash
# Creating archives
zip start_instances.zip start_instances.py
zip stop_instances.zip stop_instances.py
# Checking the archives
unzip -l start_instances.zip
unzip -l stop_instances.zip
```
![l (1).jpg](screenshots%2Fl%20%281%29.jpg)

2) Create a Trust Policy File([trust-policy.json](https://github.com/yourhostel/hw_devops/blob/main/module_3/homework-lambda-apigw/trust-policy.json)) and IAM Role for Lambda

```bash
# Creating a role
aws iam create-role --role-name lambda-ec2-role --assume-role-policy-document file://trust-policy.json
# Attaching a Policy to a Role
aws iam attach-role-policy --role-name lambda-ec2-role --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess
```

![l (2).jpg](screenshots%2Fl%20%282%29.jpg)
![l (3).jpg](screenshots%2Fl%20%283%29.jpg)

3) Creating Lambda Functions
```bash
aws lambda create-function --function-name StartEC2Instances \
--zip-file fileb://start_instances.zip --handler start_instances.lambda_handler \
--runtime python3.8 --role arn:aws:iam::590184137042:role/lambda-ec2-role

aws lambda create-function --function-name StopEC2Instances \
--zip-file fileb://stop_instances.zip --handler stop_instances.lambda_handler \
--runtime python3.8 --role arn:aws:iam::590184137042:role/lambda-ec2-role
```