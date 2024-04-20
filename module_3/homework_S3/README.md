# Homework S3

1. Create s3 bucket. Give it any unique name
2. Upload any test file to s3. Download this file to your PC
3. Create your own IAM policy which allows access to only this specific s3 bucket
4. Create your own test user and provide him only this policy
5. Login to AWS console with created user and check that this user has access only to this s3 bucket
6. Remove created user, created policy, s3 bucket

Advanced:
1. Create 2 ec2 instances with web servers
2. Put them in target group
3. Create ALB and connect to target group

## The task was completed on ubuntu 20.04

### Setting up awscli on the local machine

* _install awscli_
```bash
pip3 install awscli --upgrade --user
```
![S3 (1).jpg](screenshots%2FS3%20%281%29.jpg)
***

* _create an Access key_
![S3 (2).jpg](screenshots%2FS3%20%282%29.jpg)
![S3 (3).jpg](screenshots%2FS3%20%283%29.jpg)
***

* _setting up access_
```bash
aws configure
```
> AWS Access Key ID [None]: ****

> AWS Secret Access Key [None]: ****

> Default region name [None]: eu-north-1

> Default output format [None]: json
***

* _checking the connection_

```bash
aws sts get-caller-identity
```
```json
{
    "UserId": "AIDAYS2BDGKJJCM4KF3QE",
    "Account": "590184137042",
    "Arn": "arn:aws:iam::590184137042:user/yourhostel.ua@gmail.com"
}
```
***

### Performing the main task
* _Getting temporary credentials using two-factor authentication_
```bash
aws sts get-session-token --serial-number arn:aws:iam::590184137042:mfa/redmi1 --token-code 572227 
```
***
* _Add to environment variables_
```bash
export AWS_ACCESS_KEY_ID="ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="SECRET_ACCESS_KEY"
export AWS_SESSION_TOKEN="SESSION_TOKEN"
```
***
1.  _Сreate a bucket named "yourhostel"_
```bash
tysser@tysser:~$ aws s3 mb s3://yourhostel --region eu-north-1
```
> make_bucket: yourhostel
***
* _Checking the list buckets_
```bash
tysser@tysser:~$ aws s3 ls
```
> 2024-04-08 17:38:29 terraform-state-danit-devops-2
 
> 2024-04-20 18:20:59 yourhostel
***
2. _Upload/Download a test file to/from S3_
![S3 (4).jpg](screenshots%2FS3%20%284%29.jpg)
3. 