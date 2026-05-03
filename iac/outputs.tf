output "current_environment" {
  description = "Entorno actual de despliegue (Workspace)"
  value       = local.env
}

output "s3_bucket_name" {
  description = "Nombre del bucket de imagenes"
  value       = aws_s3_bucket.images.id
}

output "sqs_queue_url" {
  description = "URL de la cola SQS principal"
  value       = aws_sqs_queue.image_queue.id
}

output "sqs_dlq_url" {
  description = "URL de la cola de mensajes muertos (DLQ)"
  value       = aws_sqs_queue.image_dlq.id
}

output "ingest_lambda_arn" {
  description = "ARN de la Lambda de Ingesta"
  # Nota: Asegúrate de que el recurso en main.tf se llame aws_lambda_function.ingest_lambda
  value       = aws_lambda_function.ingest_lambda.arn
}

output "processor_lambda_arn" {
  description = "ARN de la Lambda de Procesamiento"
  # Nota: Asegúrate de que el recurso en main.tf se llame aws_lambda_function.process_lambda
  value       = aws_lambda_function.process_lambda.arn
}