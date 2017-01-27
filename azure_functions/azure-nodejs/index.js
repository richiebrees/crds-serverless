/*
    Template Azure Function with HTTP trigger -- adjust for testing.
*/

const MAX_ITERATIONS = 1000;

module.exports = function (context, req) {
    context.log('HTTP trigger function processed a request.');

    const response = {
        statusCode: 200,
        body: JSON.stringify({
            message: 'Go Azure!'
        }),
    };

    var responseBody = [];

    for (var i = 0; i < MAX_ITERATIONS; i++) {
        responseBody.push(i);
    }

    response.body = JSON.stringify(responseBody);

    context.done(null, response);
};