# Bucket de S3 para las imágenes
resource "aws_s3_bucket" "images" {
  bucket = "${var.project_name}-${var.environment}-${var.bucket_suffix}"

  tags = {
    Name        = "Image Processor Bucket"
    Environment = var.environment
  }
}

# Configuración de Ciclo de Vida (Lifecycle)
resource "aws_s3_bucket_lifecycle_configuration" "images_lifecycle" {
  bucket = aws_s3_bucket.images.id

  # Regla 1: Las originales en uploads/ expiran en 30 días
  rule {
    id     = "expire-uploads"
    status = "Enabled"
    filter {
      prefix = "uploads/"
    }
    expiration {
      days = 30
    }
  }

  # Regla 2: Las procesadas en processed/ expiran en 90 días
  rule {
    id     = "expire-processed"
    status = "Enabled"
    filter {
      prefix = "processed/"
    }
    expiration {
      days = 90
    }
  }
}