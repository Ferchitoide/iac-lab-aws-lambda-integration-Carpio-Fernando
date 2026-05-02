# 1. Lambda de Ingesta (S3 -> SQS)
resource "aws_lambda_function" "ingest_lambda" {
  filename      = "lambda_ingest.zip" # El profesor querrá ver el empaquetado
  function_name = "${var.project_name}-ingest"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "python3.9"

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.image_queue.id
    }
  }
}

# 2. Lambda de Procesamiento (SQS -> S3)
resource "aws_lambda_function" "process_lambda" {
  filename      = "lambda_process.zip"
  function_name = "${var.project_name}-processor"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "python3.9"
  timeout       = 60 # Un minuto para procesar imágenes pesadas

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.images.id
    }
  }
}

# Disparador (Trigger) de SQS para la Lambda de Procesamiento
resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.image_queue.arn
  function_name    = aws_lambda_function.process_lambda.arn
  batch_size       = 10
}