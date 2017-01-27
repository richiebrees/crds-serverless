/*

    NOT CURRENTLY USED!

*/

const MAX_ITERATIONS = 1000;

module.exports.createTestResponse = function (context, req) {

    var responseBody = [];

    for (var i = 0; i < MAX_ITERATIONS; i++) {
        responseBody.push(i);
    }

    response.body = JSON.stringify(responseBody);

    return response;
};