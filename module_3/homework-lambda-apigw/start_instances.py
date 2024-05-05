import boto3
import json

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')

    # Отримання списку зупинених екземплярів із потрібними тегами
    response = ec2.describe_instances(
        Filters=[
            {'Name': 'tag:Owner', 'Values': ['yourhostel']},
            {'Name': 'tag:Name', 'Values': ['*yourhostel*']},
            {'Name': 'instance-state-name', 'Values': ['stopped']}
        ]
    )

    instances_to_start = [
        instance['InstanceId']
        for reservation in response['Reservations']
        for instance in reservation['Instances']
    ]

    # Запуск екземплярів
    if instances_to_start:
        starting_response = ec2.start_instances(InstanceIds=instances_to_start)
        started_instances = [inst['InstanceId'] for inst in starting_response['StartingInstances']]
    else:
        started_instances = []

    return {
        'statusCode': 200,
        'body': json.dumps({"started_instances": started_instances}),
        'headers': {'Content-Type': 'application/json'}
    }
