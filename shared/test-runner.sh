#!/bin/bash
set -e

echo "STARTED!!!"

## settings needed for "env.sh"
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_REGION
# AWS_FUNCTION_NAME
# AZURE_FUNCTIONAPP_USER
# AZURE_FUNCTIONAPP_PASSWORD
# AZURE_FUNCTIONAPP_NAME
# AZURE_FUNCTION_NAME
# AZURE_FUNCTION_CODE
# TEST_ITERATIONS
# TEST_CONCURRENCY
# TEST_REQUESTS_PERSECOND
# TEST_TIMEOUT_MS

source env.sh

## needed for "loadtest"
#npm install
export LOADTEST_CMD=$(npm root)/loadtest/bin/loadtest.js

## needed for Azure Deployment
export AZURE_FUNCTIONAPP_CREDS=$(printf "$AZURE_FUNCTIONAPP_USER:$AZURE_FUNCTIONAPP_PASSWORD" | base64)

## aws deployment and tests
pushd ../aws_lambda
bash demo-aws-lambda.sh
popd

## azure deployment and tests
pushd ../azure_functions
bash demo-azure-functions.sh
popd

echo "DONE with ALL!!!"
