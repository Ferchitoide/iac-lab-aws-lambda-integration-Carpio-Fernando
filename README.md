# AWS Image Processor Infrastructure (IaC)

Este proyecto despliega una arquitectura de procesamiento de imágenes asíncrona utilizando Terraform.

## Requisitos
- Terraform >= 1.0.0
- AWS CLI configurado con credenciales adecuadas.

## Estructura del Proyecto
- `main.tf`: Definición de Lambdas, S3, SQS e IAM.
- `vpc.tf`: Configuración de la red (VPC, Subnets, Gateway).
- `variables.tf` y `terraform.tfvars`: Gestión de entornos (dev, qa, prod).

## Instrucciones de Despliegue
1. Inicializar el proyecto: 
   `terraform init`
2. Seleccionar o crear un entorno (workspace):
   `terraform workspace select dev`
3. Aplicar los cambios:
   `terraform apply -auto-approve`

## Destrucción de Recursos
Para evitar costos, ejecutar:
`terraform destroy -auto-approve`