import json
import boto3
import os

sqs = boto3.client('sqs')
# Esta variable la tomará automáticamente de tu configuración de Terraform
QUEUE_URL = os.environ.get('QUEUE_URL')

def handler(event, context):
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        
        message = {
            'bucket': bucket,
            'key': key,
            'status': 'uploaded'
        }
        
        sqs.send_message(
            QueueUrl=QUEUE_URL,
            MessageBody=json.dumps(message)
        )
        
    return {
        'statusCode': 200,
        'body': json.dumps('Notificación enviada a SQS')
    }