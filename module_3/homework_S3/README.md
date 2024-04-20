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
***
3. _Create your own IAM policy_
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3:::yourhostel",
        "arn:aws:s3:::yourhostel/*"
      ]
    }
  ]
}
```
```bash
aws iam create-policy --policy-name YourHostelBucketAccess --policy-document file://s3bucketpolicy.json
```
![S3 (5).jpg](screenshots%2FS3%20%285%29.jpg)
***
4. _Create your own test user and provide him only this policy_
* __Create a new IAM user__
```bash
aws iam create-user --user-name TestUserForYourHostel
```
* __Attaching a Policy to a User__
```bash
aws iam attach-user-policy --policy-arn arn:aws:iam::590184137042:policy/YourHostelBucketAccess --user-name TestUserForYourHostel
```
![S3 (6).jpg](screenshots%2FS3%20%286%29.jpg)
![S3 (7).jpg](screenshots%2FS3%20%287%29.jpg)
![S3 (8).jpg](screenshots%2FS3%20%288%29.jpg)
***
5. Login to AWS console with created user and check that this user has access only to this s3 bucket
```bash
aws iam create-login-profile --user-name TestUserForYourHostel --password iI52585654 --password-reset-required
```
![S3 (9).jpg](screenshots%2FS3%20%289%29.jpg)
* _Change the policy to allow password changes_ __s3bucketpolicy.json__
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3:::yourhostel",
        "arn:aws:s3:::yourhostel/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "iam:ChangePassword",
      "Resource": "arn:aws:iam::*:user/${aws:username}"
    }
  ]
}

```
* _Change the policy_
```bash
aws iam create-policy-version --policy-arn arn:aws:iam::590184137042:policy/YourHostelBucketAccess --policy-document file://s3bucketpolicy.json --set-as-default
```
* _Get a list of all policy versions_
```bash
aws iam list-policy-versions --policy-arn arn:aws:iam::590184137042:policy/YourHostelBucketAccess
```
![S3 (10).jpg](screenshots%2FS3%20%2810%29.jpg)
* _Detailed contents of the policy version_
```bash
aws iam get-policy-version --policy-arn arn:aws:iam::590184137042:policy/YourHostelBucketAccess --version-id v4
```
![S3 (11).jpg](screenshots%2FS3%20%2811%29.jpg)
* _Checking the operation of the policy for the yourhostel bucket under the user TestUserForYourHostel_
![S3 (12).jpg](screenshots%2FS3%20%2812%29.jpg)
![S3 (13).jpg](screenshots%2FS3%20%2813%29.jpg)
* _Download the file to your local computer using the profile TestUserForYourHostel_
![S3 (14).jpg](screenshots%2FS3%20%2814%29.jpg)
***
6. _Cleanup AWS Resources_

__Remove IAM Policy__

```bash
# also (v2, v3) but v4 - current and deleting it will cause an error
aws iam delete-policy-version --policy-arn arn:aws:iam::590184137042:policy/YourHostelBucketAccess --version-id v1
```
![S3 (15).jpg](screenshots%2FS3%20%2815%29.jpg)
```bash
# Checking to which entities the policy is applied.
aws iam list-entities-for-policy --policy-arn arn:aws:iam::590184137042:policy/YourHostelBucketAccess
```
```json
{
    "PolicyGroups": [],
    "PolicyUsers": [
        {
            "UserName": "TestUserForYourHostel",
            "UserId": "AIDAYS2NXIFJGJNYATHGB"
        }
    ],
    "PolicyRoles": []
}
```

```bash
# Unpin a policy from a user
aws iam detach-user-policy --user-name TestUserForYourHostel --policy-arn arn:aws:iam::590184137042:policy/YourHostelBucketAccess
```

```bash
# Removing the policy
aws iam delete-policy --policy-arn arn:aws:iam::590184137042:policy/YourHostelBucketAccess
```
__Remove IAM User__
```bash
# Delete login profile if it exists
aws iam delete-login-profile --user-name TestUserForYourHostel

# List and delete access keys if they exist
aws iam list-access-keys --user-name TestUserForYourHostel

# Then for each AccessKeyId:
aws iam delete-access-key --access-key-id <AccessKeyId> --user-name TestUserForYourHostel

# Finally, delete the user
aws iam delete-user --user-name TestUserForYourHostel
```
__Remove S3 Bucket and Its Contents__
```bash
# Remove all objects within the bucket
aws s3 rm s3://yourhostel --recursive

# Remove the bucket itself
aws s3 rb s3://yourhostel
```
![S3 (16).jpg](screenshots%2FS3%20%2816%29.jpg)