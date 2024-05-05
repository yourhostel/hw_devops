# Homework AWS Lambda API GW

[homework-20240425-lambda-apigw](https://gitlab.com/dan-it/groups/devops2/homework/-/blob/main/homework-20240425-lambda-apigw.md)

### 1. Writing scripts([start_instances.py](https://github.com/yourhostel/hw_devops/blob/main/module_3/homework-lambda-apigw/start_instances.py), [stop_instances.py](https://github.com/yourhostel/hw_devops/blob/main/module_3/homework-lambda-apigw/stop_instances.py)) and adding to the archive.
```bash
# Creating archives
zip start_instances.zip start_instances.py
zip stop_instances.zip stop_instances.py
# Checking the archives
unzip -l start_instances.zip
unzip -l stop_instances.zip
```
![l (1).jpg](screenshots%2Fl%20%281%29.jpg)

### 2. Create a Trust Policy File( [trust-policy.json](https://github.com/yourhostel/hw_devops/blob/main/module_3/homework-lambda-apigw/trust-policy.json) ) and IAM Role for Lambda

```bash
# Creating a role
aws iam create-role --role-name lambda-ec2-role --assume-role-policy-document file://trust-policy.json
# Attaching a policy to work with EC2 (if functions need to manage EC2 instances)
aws iam attach-role-policy --role-name lambda-ec2-role --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess
# Attaching a policy for logging to CloudWatch
aws iam attach-role-policy --role-name lambda-ec2-role --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
```

![l (2).jpg](screenshots%2Fl%20%282%29.jpg)
![l (3).jpg](screenshots%2Fl%20%283%29.jpg)

### 3. Creating Lambda Functions
```bash
aws lambda create-function --function-name StartEC2Instances \
--zip-file fileb://start_instances.zip --handler start_instances.lambda_handler \
--runtime python3.8 --role arn:aws:iam::590184137042:role/lambda-ec2-role

aws lambda create-function --function-name StopEC2Instances \
--zip-file fileb://stop_instances.zip --handler stop_instances.lambda_handler \
--runtime python3.8 --role arn:aws:iam::590184137042:role/lambda-ec2-role

aws lambda update-function-configuration --function-name StartEC2Instances --timeout 30
aws lambda update-function-configuration --function-name StopEC2Instances --timeout 30
```

![l (4).jpg](screenshots%2Fl%20%284%29.jpg)
![l (5).jpg](screenshots%2Fl%20%285%29.jpg)
![l (6).jpg](screenshots%2Fl%20%286%29.jpg)
![l (7).jpg](screenshots%2Fl%20%287%29.jpg)

### 4. Creating an API Gateway 

- ***Creating API Gateway***
A new REST API is created in AWS API Gateway based on the data from the [api-config.json](https://github.com/yourhostel/hw_devops/blob/main/module_3/homework-lambda-apigw/api-config.json) file.

- ***Defining Endpoints***
The API is configured with endpoints `/instances/start` and `/instances/stop`, each corresponding to specific operations for managing EC2 instances.

- ***HTTP Methods***
Each endpoint accepts the HTTP POST method. This means that to execute operations, POST requests must be sent to these endpoints.

- ***Integration with Lambda***
The endpoints are integrated with the Lambda functions `StartEC2Instances` and `StopEC2Instances` through the `aws_proxy` integration type. This ensures direct transmission of requests and responses between API Gateway and Lambda.

- ***Access Management via API Keys***
Access to the API is controlled through API keys. Clients are required to include a valid key in the `x-api-key` header for each request.

- ***Automatic Configuration***
Since the entire configuration process is described in the configuration file, its deployment occurs automatically.


```bash
 aws apigateway import-rest-api --body 'file://api-config.json'
```

![l (8).jpg](screenshots%2Fl%20%288%29.jpg)
![l (9).jpg](screenshots%2Fl%20%289%29.jpg)

### 5. Setting Lambda functions a permission policy that allows calls from API Gateway.

```bash
# StartEC2Instances
aws lambda add-permission --function-name StartEC2Instances \
--statement-id apigateway-test \
--action lambda:InvokeFunction \
--principal apigateway.amazonaws.com \
--source-arn "arn:aws:execute-api:eu-north-1:590184137042:ozqw4jyu0h/*/POST/instances/start"
# StopEC2Instances
aws lambda add-permission --function-name StopEC2Instances \
--statement-id apigateway-test-stop \
--action lambda:InvokeFunction \
--principal apigateway.amazonaws.com \
--source-arn "arn:aws:execute-api:eu-north-1:590184137042:ozqw4jyu0h/*/POST/instances/stop"
```

### Explanation of the added policy:
- `--function-name StopEC2Instances`: Specifies the name of the Lambda function to which permissions are added.
- `--statement-id apigateway-test-stop`: Unique identifier for this permission policy. This value must be unique within the Lambda function.
- `--action lambda:InvokeFunction`: Allows the Lambda function to be called.
- `--principal apigateway.amazonaws.com`: Specifies that permissions are granted by API Gateway.
- `--source-arn`: ARN of the resource that will call Lambda. This is the ARN of the API Gateway and a specific method (in this case, POST to stop instances). Asterisks (*) indicate that the permission applies to all request types and stages.

### 6. Creating a stage

```bash
aws apigateway create-deployment --rest-api-id ozqw4jyu0h --stage-name test --description 'Test stage for API'
```
### 7. Create a usage plan
```bash
ws apigateway create-usage-plan --name 'BasicUsagePlan' --description 'Basic usage plan for testing' --api-stages apiId=ozqw4jyu0h,stage=test
```

### 8. Creating an API key

```bash
 aws apigateway create-api-key --name 'YourhostelAPIKey' --enabled
```

### 9. Associate a new API key with a usage plan
```bash
aws apigateway create-usage-plan-key --usage-plan-id ujx73w --key-id bggc7734fk --key-type API_KEY
```

![l (12).jpg](screenshots%2Fl%20%2812%29.jpg)

### 10. Endpoint testing
- AWS console

![l (13).jpg](screenshots%2Fl%20%2813%29.jpg)
![l (14).jpg](screenshots%2Fl%20%2814%29.jpg)
![l (15).jpg](screenshots%2Fl%20%2815%29.jpg)
![l (16).jpg](screenshots%2Fl%20%2816%29.jpg)
![l (17).jpg](screenshots%2Fl%20%2817%29.jpg)

- Postman

![l (18).jpg](screenshots%2Fl%20%2818%29.jpg)
![l (19).jpg](screenshots%2Fl%20%2819%29.jpg)
