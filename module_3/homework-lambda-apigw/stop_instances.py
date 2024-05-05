import boto3
import json

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')

    # Отримання списку запущених екземплярів із потрібними тегами
    response = ec2.describe_instances(
        Filters=[
            {'Name': 'tag:Owner', 'Values': ['yourhostel']},
            {'Name': 'tag:Name', 'Values': ['*yourhostel*']},
            {'Name': 'instance-state-name', 'Values': ['running']}
        ]
    )

    instances_to_stop = [
        instance['InstanceId']
        for reservation in response['Reservations']
        for instance in reservation['Instances']
    ]

    # Stopping Instances
    if instances_to_stop:
        stopping_response = ec2.stop_instances(InstanceIds=instances_to_stop)
        stopped_instances = [inst['InstanceId'] for inst in stopping_response['StoppingInstances']]
    else:
        stopped_instances = []

    return {
        'statusCode': 200,
        'body': json.dumps({"stopped_instances": stopped_instances}),
        'headers': {'Content-Type': 'application/json'}
    }
