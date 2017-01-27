#!/bin/bash
set -e

REGEX="https://.*/runTest"

#read -p "Press ENTER to start deployment to AWS"
echo "deploying to AWS"
sls deploy --region $AWS_REGION

API_URL=$(sls info --region $AWS_REGION | grep -o $REGEX)

echo "sleeping for 1m"
sleep 60

## perform load test
#read -p "Press ENTER to begin testing"
echo "load testing started"
node $LOADTEST_CMD --rps $TEST_REQUESTS_PERSECOND -n $TEST_ITERATIONS -c $TEST_CONCURRENCY --timeout $TEST_TIMEOUT_MS $API_URL > ./output/test-output.txt
echo "load testing completed"

#read -p "Press ENTER to remove deployment from AWS"
echo "removing from AWS"
sls remove --region $AWS_REGION
echo "DONE with AWS!!!"
