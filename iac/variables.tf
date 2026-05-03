variable "project_name" {
  type    = string
  default = "image-processor"
}

variable "environment" {
  type        = string
  description = "Entorno de despliegue (dev, qa, prod)"
}

variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "bucket_suffix" {
  type    = string
  default = "ferchito-2026"
}

variable "lambda_runtime" {
  type        = string
  description = "Runtime para las funciones Lambda"
  default     = "python3.9"
}