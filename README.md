# Laboratorio: Integración AWS + Lambda (IaC) 🚀

Este proyecto implementa una arquitectura serverless para el procesamiento asíncrono de imágenes utilizando **Terraform** como herramienta de Infraestructura como Código (IaC).

## 🏗️ Arquitectura del Sistema
El sistema sigue el flujo diseñado en el diagrama de Mermaid proporcionado:
1. **S3 Bucket**: Almacenamiento de imágenes con políticas de ciclo de vida (30/90 días).
2. **SQS & DLQ**: Cola de mensajería para desacoplamiento y manejo de errores.
3. **AWS Lambda**: Funciones para ingesta y procesamiento asíncrono.
4. **VPC & Security**: Configuración de red privada y Endpoints para máxima seguridad.

## 🛠️ Tecnologías Utilizadas
* **Terraform**: Orquestación de infraestructura.
* **AWS**: Proveedor de nube.
* **Python**: Lógica de las funciones Lambda.
* **GitHub**: Control de versiones y bitácora de hitos.

## 🚀 Cómo Validar el Proyecto