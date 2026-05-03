import json
import boto3

s3 = boto3.client('s3')

def handler(event, context):
    for record in event['Records']:
        # SQS manda el mensaje dentro de 'body'
        body = json.loads(record['body'])
        bucket = body['bucket']
        key = body['key']
        
        # Definimos la ruta de destino (dentro del mismo bucket)
        copy_source = {'Bucket': bucket, 'Key': key}
        filename = key.split('/')[-1]
        new_key = f"processed/{filename}"
        
        # Copiamos y luego borramos el original (simula movimiento)
        s3.copy_object(Bucket=bucket, CopySource=copy_source, Key=new_key)
        s3.delete_object(Bucket=bucket, Key=key)
        
        print(f"Imagen {filename} procesada y movida a carpeta processed/")

    return {
        'statusCode': 200,
        'body': json.dumps('Procesamiento finalizado')
    }