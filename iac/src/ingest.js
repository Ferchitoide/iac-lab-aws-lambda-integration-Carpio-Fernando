const { SQSClient, SendMessageCommand } = require("@aws-sdk/client-sqs");
const sqs = new SQSClient({});

exports.handler = async (event) => {
    const queueUrl = process.env.QUEUE_URL; // Asegúrate de que coincida con tu variable de entorno en Terraform

    for (const record of event.Records) {
        const message = {
            bucket: record.s3.bucket.name,
            key: record.s3.object.key,
            status: 'uploaded'
        };

        const command = new SendMessageCommand({
            QueueUrl: queueUrl,
            MessageBody: JSON.stringify(message),
        });

        try {
            await sqs.send(command);
            console.log("Notificación enviada a SQS:", message);
        } catch (err) {
            console.error("Error enviando a SQS:", err);
        }
    }

    return {
        statusCode: 200,
        body: JSON.stringify('Notificación procesada exitosamente')
    };
};