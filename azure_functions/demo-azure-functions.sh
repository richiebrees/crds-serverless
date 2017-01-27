#!/bin/bash
set -e

## Deploys, Tests, and Removes Azure Function with HTTP Trigger

## credentials needed by KUDO
API_BASE_URL="https://${AZURE_FUNCTIONAPP_NAME}.scm.azurewebsites.net"
FUNCTION_URL="https://${AZURE_FUNCTIONAPP_NAME}.azurewebsites.net/api/${AZURE_FUNCTION_NAME}?code=${AZURE_FUNCTION_CODE}"
NEW_CODE_JSON="{\"keys\":[{\"name\":\"crds-automation-test\",\"value\":\"$AZURE_FUNCTION_CODE\",\"encrypted\":false}]}"
AZURE_AUTH_HEADER="Basic $AZURE_FUNCTIONAPP_CREDS"


## prepare file
echo "zipping folder $AZURE_FUNCTION_NAME"
rm -f $AZURE_FUNCTION_NAME.zip
zip -r  ./output/$AZURE_FUNCTION_NAME.zip $AZURE_FUNCTION_NAME

## deployment
#read -p "Press ENTER to deploy function to Azure"
echo "uploading archive"
curl -X PUT $API_BASE_URL/api/zip/site/wwwroot/ --header "Authorization: $AZURE_AUTH_HEADER" --header "Content-Type: multipart/form-data" --data-binary @./output/${AZURE_FUNCTION_NAME}.zip --verbose

## testing
#read -p "Press ENTER to begin testing (need to allow some delay before calling endpoint!)"

echo "sleeping for 1m"
sleep 60

## update code
echo "updating access code"
curl -X PUT "${API_BASE_URL}/api/vfs/data/functions/secrets/${AZURE_FUNCTION_NAME}.json" --header "Authorization: $AZURE_AUTH_HEADER" --header "if-match:*" --data $NEW_CODE_JSON

echo "sleeping for 1m"
sleep 60

echo "load testing started"
## load test
node $LOADTEST_CMD --rps $TEST_REQUESTS_PERSECOND -n $TEST_ITERATIONS -c $TEST_CONCURRENCY --timeout $TEST_TIMEOUT_MS $FUNCTION_URL > ./output/test-output.txt
echo "load testing completed"

## teardown
#read -p "Press ENTER to remove function from Azure"
echo "removing function from Azure"
curl -X DELETE $API_BASE_URL/api/functions/$AZURE_FUNCTION_NAME --header "Authorization: $AZURE_AUTH_HEADER" --verbose

echo "DONE with Azure!!!"

