variable "project_name" {
  type    = string
  default = "image-processor"
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
  default     = "nodejs18.x"
}

# Variable auxiliar para el tag de entorno
variable "environment" {
  type        = string
  description = "Entorno de despliegue (dev, qa, prod)"
  default     = ""
}

# Lógica para detectar el entorno automáticamente
locals {
  # Si el workspace es 'default', lo tratamos como 'dev'. 
  # De lo contrario, usamos el nombre del workspace (dev, qa, prod).
  env = terraform.workspace == "default" ? "dev" : terraform.workspace
}