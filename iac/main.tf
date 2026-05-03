# CONFIGURACIÓN DE TERRAFORM Y PROVIDER 
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = local.env
      Owner       = "Carpio-Fernando"
      ManagedBy   = "Terraform"
    }
  }
}

# RECURSOS DE ALMACENAMIENTO Y MENSAJERÍA
resource "aws_s3_bucket" "images" {
  bucket        = "${var.project_name}-${local.env}-${var.bucket_suffix}"
  force_destroy = true 
}

resource "aws_sqs_queue" "image_queue" {
  name = "${var.project_name}-${local.env}-main-queue"
}

resource "aws_sqs_queue" "image_dlq" {
  name = "${var.project_name}-${local.env}-dlq"
}

# EMPAQUETADO AUTOMÁTICO DE CÓDIGO (NODE.JS)
data "archive_file" "ingest_zip" {
  type        = "zip"
  source_file = "${path.module}/src/ingest.js"
  output_path = "${path.module}/ingest.zip"
}

data "archive_file" "process_zip" {
  type        = "zip"
  source_file = "${path.module}/src/process.js"
  output_path = "${path.module}/process.zip"
}
# LAMBDA DE INGESTA (NODE.JS)
resource "aws_lambda_function" "ingest_lambda" {
  function_name = "${var.project_name}-${local.env}-ingestor"
  role          = aws_iam_role.lambda_role.arn
  handler       = "ingest.handler" # Referencia a ingest.js
  runtime       = "nodejs18.x"     # Forzado a Node.js según diagrama

  filename         = data.archive_file.ingest_zip.output_path
  source_code_hash = data.archive_file.ingest_zip.output_base64sha256

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.images.id
      QUEUE_URL   = aws_sqs_queue.image_queue.id
      ENV         = local.env
    }
  }
}

# LAMBDA DE PROCESAMIENTO (NODE.JS)
resource "aws_lambda_function" "process_lambda" {
  function_name = "${var.project_name}-${local.env}-processor"
  role          = aws_iam_role.lambda_role.arn
  handler       = "process.handler" # Referencia a process.js
  runtime       = "nodejs18.x"     # Forzado a Node.js según diagrama

  filename         = data.archive_file.process_zip.output_path
  source_code_hash = data.archive_file.process_zip.output_base64sha256

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.images.id
      QUEUE_URL   = aws_sqs_queue.image_queue.id
      ENV         = local.env
    }
  }
}

# ROL DE IAM Y POLÍTICAS
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-${local.env}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.project_name}-${local.env}-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["s3:PutObject", "s3:GetObject", "s3:ListBucket"]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.images.arn}",
          "${aws_s3_bucket.images.arn}/*"
        ]
      },
      {
        Action = ["sqs:SendMessage", "sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
        Effect = "Allow"
        Resource = "${aws_sqs_queue.image_queue.arn}"
      },
      {
        Action = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Effect = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# TRIGGERS / DISPARADORES

# Permiso para S3 -> Lambda
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ingest_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.images.arn
}

# Evento S3 -> Ingestor
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.images.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.ingest_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}

# Evento SQS -> Processor
resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.image_queue.arn
  function_name    = aws_lambda_function.process_lambda.arn
  enabled          = true
  batch_size       = 10
}