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
  default = "us-east-1"
}

variable "bucket_suffix" {
  type    = string
  default = "ferchito-2026"
}