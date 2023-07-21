const AWS = require('aws-sdk');
const dynamoDB = new AWS.DynamoDB.DocumentClient({ region: "us-east-1" });

exports.handler = async (event, context, callback) => {
    const request = event.Records[0].cf.request;

    const allowedIPTable = 'allowed_ip'; // Replace with your DynamoDB table name

    try {
        const params = {
            TableName: allowedIPTable,
        };
        const result = await dynamoDB.scan(params).promise();

        const allowedIPs = result.Items.map(item => item.ip);
        const clientIP = request.clientIp;

        if (!allowedIPs.includes(clientIP)) {
            const errorPage = `<!DOCTYPE html>
                <html lang="en">
                  <head>
                    <meta charset="utf-8" />
                    <link rel="icon" href="%PUBLIC_URL%/favicon.ico" />
                    <meta name="viewport" content="width=device-width, initial-scale=1" />
                    <meta name="theme-color" content="#000000" />
                    <meta name="description" content="test"  />
                    <link rel="apple-touch-icon" href="%PUBLIC_URL%/favicon.ico" />
                    <link rel="manifest" href="%PUBLIC_URL%/manifest.json" />
                    <title>test</title>
                  </head>
                  <body style="margin: 0px; padding: 0px;">
                    <div style="display: flex; justify-content: center; align-items: center; background-color: #ffff01; width: 100%; height: 100vh; ">
                    <img width="50%" height="auto" src="https://s3.amazonaws.com/ip-restrict-img-bucket/error.png" ></div>
                  </body>
                </html>
                `;
            const errorResponse = {
                status: '403',
                statusDescription: 'Forbidden',
                headers: {
                    'content-type': [{
                        key: 'Content-Type',
                        value: 'text/html',
                    }],
                },
                body: errorPage,
            };
            return errorResponse;
        } else {
            return request;
        }
    } catch (error) {
        console.log('Error retrieving IPs from DynamoDB:', error);
        const errorResponse = {
            status: '500',
            statusDescription: 'Internal Server Error',
            headers: {
                'content-type': [{
                    key: 'Content-Type',
                    value: 'text/html',
                }],
            },
            body: "<html><body><h1>Internal Server Error</h1><p>An error occurred while processing your request.</p></body></html>",
        };
        return errorResponse;
    }
};