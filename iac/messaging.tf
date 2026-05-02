# Cola de Mensajes Fallidos (Dead-Letter Queue - DLQ)
resource "aws_sqs_queue" "image_dlq" {
  name                      = "${var.project_name}-${var.environment}-image-dlq"
  message_retention_seconds = 1209600 # 14 días para que no se borren rápido los errores

  tags = {
    Environment = var.environment
  }
}

# Cola Principal de Procesamiento (SQS)
resource "aws_sqs_queue" "image_queue" {
  name                      = "${var.project_name}-${var.environment}-image-queue"
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 86400 # 1 día de vida para mensajes normales
  receive_wait_time_seconds = 20    # Long polling (ahorra costos y peticiones)
  visibility_timeout_seconds = 300   # La Lambda tiene 5 min para procesar

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.image_dlq.arn
    maxReceiveCount     = 3
  })

  tags = {
    Environment = var.environment
  }
}