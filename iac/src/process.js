exports.handler = async (event) => {
    for (const record of event.Records) {
        const body = JSON.parse(record.body);
        console.log("Procesando mensaje de SQS...");
        console.log("Imagen recibida:", body.key, "del bucket:", body.bucket);
    }

    return {
        statusCode: 200,
        body: JSON.stringify('Mensajes procesados')
    };
};