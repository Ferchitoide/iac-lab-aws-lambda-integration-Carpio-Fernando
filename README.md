Laboratorio Final: Infraestructura como Código (IaC) con AWS
Estudiante: Luis Fernando Carpio Velásquez
Carrera: Ingeniería de Sistemas e Inteligencia Artificial - UPAO
Docente: Walter Leturia

Descripción del Proyecto B|:

Este proyecto despliega una arquitectura asíncrona en AWS utilizando Terraform. Implementa la ingesta de imágenes en Amazon S3, el procesamiento de eventos mediante SQS y la ejecución de lógica mediante funciones AWS Lambda, todo dentro de una red privada (VPC) con subredes públicas y privadas.  

Requisitos Previos *super importantes pa que funcione SI O SI*:

Antes de iniciar el despliegue, asegúrese ingeniero de contar con:

Terraform CLI instalado (versión v1.0.0+).
AWS CLI configurado con credenciales de Administrador (aws configure).
Los archivos de código de la Lambda (ingest.zip y lambda_function.zip) deben estar en la carpeta raíz del proyecto o en sus rutas correspondientes.  

Instrucciones pal despliegue:
Siga estos pasos en orden para evitar errores de estado o de región:

Inicializar el Directorio:
Sitúese en la carpeta del proyecto donde se encuentran los archivos .tf y ejecute el poderoso "terraform init"
Luego para probar los 3 entornos como los pidió (dev,qa,prod) es necesario ejecutar el terraform workspace new (el entorno) y luego su terraform select (de igual manera el entorno), darle terraform plan y por último su terraform apply.
Luego de eso ya reflejará en la cuenta de AWS previamente configurada para que se puedan ver todos los cambios a la hora de ejecutar el terraform apply.

De todas maneras de manera preventiva (para que no se generen costos ni nada ya que al ser distintos entorno no se borra todo con el poderosísimo terraform destroy) se ejecuta el terraform destroy pero en el workspace default, de esta manera se garantiza una cuenta con cero recursos activos B|.

Eso fue todo, muchas gracias afición, siuuuu o7.