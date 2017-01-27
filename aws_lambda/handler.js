'use strict';

const MAX_ITERATIONS = 1000;

module.exports.runTest = (event, context, callback) => {
  
  const response = {
    statusCode: 200,
    body: JSON.stringify({
      message: 'Go Serverless v1.0! Your function executed successfully!', // will be overridden
      input: event,
    }),
  };

  var responseBody = [];

  for(var i = 0; i < MAX_ITERATIONS;i++)
  {
    responseBody.push(i);
  }

  response.body = JSON.stringify(responseBody);

  callback(null, response);

  // Use this code if you don't use the http event with the LAMBDA-PROXY integration
  // callback(null, { message: 'Go Serverless v1.0! Your function executed successfully!', event });
};
