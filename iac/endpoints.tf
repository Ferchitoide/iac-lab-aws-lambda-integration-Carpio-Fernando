# Endpoint de Gateway para S3
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  tags = {
    Name = "${var.project_name}-s3-endpoint"
  }
}

# Asociación del Endpoint de S3 con las tablas de rutas
resource "aws_vpc_endpoint_route_table_association" "private_s3_a" {
  route_table_id  = aws_vpc.main.main_route_table_id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

# Endpoint de Interface para SQS (para el puerto 443)
resource "aws_vpc_endpoint" "sqs" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.sqs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  security_group_ids = [aws_security_group.vpc_endpoints.id]

  tags = {
    Name = "${var.project_name}-sqs-endpoint"
  }
}