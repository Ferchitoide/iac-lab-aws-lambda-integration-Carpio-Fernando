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

  # Estas etiquetas se aplicarán a TODOS los recursos automáticamente
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = local.env
      Owner       = "Carpio-Fernando"
      ManagedBy   = "Terraform"
    }
  }
}

# --- ALMACENAMIENTO (S3) ---
resource "aws_s3_bucket" "images" {
  # El nombre cambiará según el entorno: image-processor-dev-ferchito-2026, etc.
  bucket = "${var.project_name}-${local.env}-${var.bucket_suffix}"
  
  force_destroy = true # Útil para laboratorios, permite borrar el bucket aunque tenga archivos
}

# --- MENSAJERÍA (SQS) ---
resource "aws_sqs_queue" "image_queue" {
  name = "${var.project_name}-${local.env}-main-queue"
}

resource "aws_sqs_queue" "image_dlq" {
  name = "${var.project_name}-${local.env}-dlq"
}

# --- PROCESAMIENTO (Lambda) ---
# Nota: Asegúrate de tener el archivo lambda_function.zip en la carpeta
resource "aws_lambda_function" "process_lambda" {
  function_name = "${var.project_name}-${local.env}-processor"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = var.lambda_runtime
  filename      = "lambda_function.zip"

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.images.id
      QUEUE_URL   = aws_sqs_queue.image_queue.id
      ENV         = local.env
    }
  }
}

# --- ROL DE IAM (Mínimo necesario para la Lambda) ---
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