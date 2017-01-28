# crds-serverless

Scripted test run of Node.js running in AWS Lambda and Azure Functions.

## Getting Started

These instructions will help ensure you have all dependencies addressed before attempting to run the _serverless automation deployment and testing_.

### Prerequisites

* node.js
* Serverless framework | [website](https://serverless.com)
* AWS CLI | [SDK](https://aws.amazon.com/cli/)
* AWS Account 
* Azure Subscription

### Azure Setup

#### Function App
Steps to setup the host for the Azure Function:

1. Create Azure Subscription, unless you already have one | [Sign-up](https://azure.microsoft.com/en-us/free/)
2. Sign into [Azure Portal](https://portal.azure.com)
3. Click on the "+" button in the top left of the view
4. Search for _Function App_ and then click _Function App_ from the results, and then click _Create_
5. Enter the following information (go ahead and change values, but you'll need to reference them later in these instructions)
	* _App Name_ : __crds-functions__  -- this needs to be unique among all of Azure's webapps
	* _Subscription_ : __{select your subscription}__
	* _Resource Group_ : __rg_crds__
	* _Hosting Plan_ : __Consumption Plan__ -- this is a _pay only what you use_ pricing model, including a 'free tier'
	* _Location_ : __East US__ -- _East US_ and _East US 2_ are both _Virginia_ in the Azure world
	* _Storage Account_ : __create new__ -- this name needs to be unique among all of Azure's storage accounts
	* __Click Create__

#### Deployment Credentials
In order to automate the deployment, setup, and removal of the Azure Function through a REST API, the deployment credentials need to be created and prepared for use by the automation script.  
After Azure has provisioned the Function App service, do the following:

1. Go to the newly created Function App.  This can be done by searching for it by name in the search box at the top of the view
2. Click _Function App Settings_
3. Click _Go to App Service Settings_
4. Click _Deployment Credentials_
5. Set the deployment credentials:
	* _FTP/deployment username_ : **crds_functions_user**
	* _Password_ and _Confirm Password_ : **{a decent password}**
	* Click **Save**


### AWS Setup
1. Create AWS Account, unless you already have one | [AWS Sign-In/Up](aws.amazon.com)
2. Log into the AWS Management Console and go to **IAM** (Identity and Access Management)
3. Go to _Groups_ and create new group named **Developers**
4. Attach the **Administrator Access** policy to this group -- this is needed so _Serverless_ can create all of the deployment artifacts needed
5. Create new _User_ and add it to the **Developers** group
	* _Access Type_ should be **Programmatic Access**
6. View the _User_ and view _Security Credentials_
7. Click **Create access key** and save the **Access key ID** and **Secret** -- the key will no longer be visible in the portal


## Setting Environment Variables
1. Create a file named **env.sh** in the _./shared directory_ and set the variables identified in the **test-runner.sh** file
	* `export AWS_ACCESS_KEY_ID="{AWS IAM ACCESS ID}"`
	* `export AWS_SECRET_ACCESS_KEY="{AWS IAM ACCESS SECRET}"`
	* `export AWS_REGION="us-east-2"`
	* `export AWS_FUNCTION_NAME="{Name of the Azure Function folder (i.e., 'azure-nodejs')}"`
	* `export AZURE_FUNCTIONAPP_USER="{Azure Deployment User}"`
	* `export AZURE_FUNCTIONAPP_PASSWORD="{Azure Deployment Password}"`
	* `export AZURE_FUNCTIONAPP_NAME="{Name of the Function App created in Azure}"`
	* `export AZURE_FUNCTION_NAME="{Name of the Azure Function folder (i.e., 'azure-nodejs')}"`
	* `export AZURE_FUNCTION_CODE="{any string value for an access code}"`
	* `export TEST_ITERATIONS=1000`
	* `export TEST_CONCURRENCY=10`
	* `export TEST_REQUESTS_PERSECOND=10`
	* `export TEST_TIMEOUT_MS=10000`

## Running the tests

Once all of the Prerequisites have been met and Configuration set, the entire test can be run by executing the following script in the _./shared_ folder:
**test-runner.sh**

The following events will occur during the script's execution:

1. Set environment variables from the **env.sh** file
2. Execute the **demo-aws-lambda.sh** script
	1. Deploy **handler.js** function to Lambda and create endpoint in API Gateway using **Serverless**
	2. Run a loadtest using **loadtest** npm package
	3. Store loadtest results to the _./output_ folder
	4. Remove function from Lambda and endpoint from API Gateway using **Serverless**
3. Execute the **demo-azure-functions.sh** script
	1. Archive the folder containing the function into the _./output_ folder
	2. Upload archive to Azure Function App using _curl_
	3. Delay 60 seconds to allow Azure to finish processing the uploaded file
	4. Update the _access code_ for the function
	5. Delay another 60 seconds to allow Azure to apply the new Setting
	6. Run a loadtest using **loadtest** npm package
	7. Store loadtest results to the _./output_ folder
	8. Remove function From Azure Functin App using _curl_

The test results will be located in the _./output_ folder under the _aws_lambda_ and _azure-functions_ folders.


## TODO:
* Use single source file for Javascript file -- will require some modification on the response that Lambda or Azure Functions returns
* Perform more complex logic in test (simple activity in Javascript file was to not bring in any latency in an accessed service, such as _DynamoDB_ or _Azure Table Storage_)
* Script entire creation of Azure Resource Group and Azure Function App
* Script entire removal of Azure Resource Group -- was unable to script it (outside of Powershell) because of _locks_ created on the resource group.  It will require a more complex script than there was capacity to create.
* When **Serverless** includes Azure Functions, use it to deploy to Azure Function App instead of _curl_

## Authors
**Richie Brees** - *Initial work* - [richiebrees](https://github.com/richiebrees)

