Laboratorio Final: Infraestructura como Código (IaC) con AWS
Estudiante: Luis Fernando Carpio Velásquez
Carrera: Ingeniería de Sistemas e Inteligencia Artificial - UPAO
Docente: Ing. Walter Leturia

Descripción del Proyecto B|:
Este proyecto despliega una arquitectura asíncrona en AWS utilizando Terraform. Implementa la ingesta de imágenes en Amazon S3, el procesamiento de eventos mediante SQS y la ejecución de lógica mediante funciones AWS Lambda (migradas a Node.js 18.x), todo dentro de una red privada (VPC) con subredes públicas y privadas.

Requisitos Previos *super importantes pa que funcione SI O SI o7*:
Antes de iniciar el despliegue, asegúrese ingeniero de contar con:

Terraform CLI instalado (versión v1.0.0+).

AWS CLI configurado con credenciales de Administrador (aws configure sso).

Los archivos de código: Los archivos ingest.zip y process.zip (generados desde la carpeta src/) deben estar en la carpeta raíz del proyecto, sino les dará fallos como a mí hasta que lo cambien.

Instrucciones pal despliegue:
Siga estos pasos en orden para evitar errores de estado o de región:

Inicializar el Directorio: Sitúese en la carpeta del proyecto donde se encuentran los archivos .tf y ejecute el poderoso terraform init.

Gestión de Entornos: Para probar los 3 entornos como los pidió (dev, qa, prod), es necesario ejecutar el terraform workspace select [entorno]. Si es la primera vez, use terraform workspace new [entorno].

Ejecución: Luego de seleccionar el workspace, darle su terraform plan y por último su terraform apply. Esto reflejará los cambios en la cuenta de AWS 7826-8389-7946 (Carpio Upao) automáticamente.

Limpieza de Recursos:
De manera preventiva, para que no se generen costos (ya que al ser distintos entornos no se borra todo con un solo comando), se debe ejecutar el terraform destroy dentro de cada workspace (dev, qa y prod). De esta manera se garantiza una cuenta con cero recursos activos B|.

Eso fue todo, muchas gracias afición, siuuuu o7.