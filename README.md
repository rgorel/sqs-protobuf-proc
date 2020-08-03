# SQS + Protobuf AWS Demo
The AWS [CDK](https://aws.amazon.com/cdk/) application consisting of three main parts:
1. Producer lambda function written in Ruby - publishes an example SQS message encoded in Protobuf
2. Consumer lambda function written in Python - consumes the message published by the producer function, decodes it from the Protobuf and writes its textual representation into the output
3. SQS Queue that serves as the communication layer between two functions.

## Prerequisites
* Docker & Docker Compose
* AWS Account
* Configured `~/.aws/credentials` file on the host machine (e.g. via `aws configure`)

## Installation

Build the Ruby application:

```
docker-compose up build_ruby

```
Build the Python application:

```
docker-compose up build_python
```

Build the CDK application:

```
docker-compose up build_cdk
```

Enter the CDK shell:

```
docker-compose run --rm cdk
```

In the CDK shell, bootstrap the app stack in the AWS account:

```
cdk bootstrap
```

After the app is bootstrapped, you can deploy it:

```
cdk deploy
```

(if you use multiple accounts in `~/.aws/credentials` you can specify the account via `--profile` option, see `cdk --help`)

## Usage

After the CDK app is deployed, find your app stack in [AWS Lambda Dashboard](https://eu-west-1.console.aws.amazon.com/lambda/home#/applications) and click on it.

In the app stack, find the producer lambda function, add a test event for it (by clicking _Configure Test Events_ in the top bar, the content of the test event could be anything, e.g. empty object `{}`) and click _Test_ button to trigger it. You'll see the published message in the output.

Do the same for the consumer function. You'll see exactly the same message in the output.

## Changes in the Protobuf schema
All changes in the communication protocol should be done in the `lambda/message.proto` file. Then the protobuf classes should be recompiled for both producer and consumer. This could easily be done via the following docker-compose command:

```
docker-compose up compile_protobuf
```

Then you should rebuild the Python app (this is related to the way how it's packaged):

```
docker-compose up build_python
```

After that you can deploy the stack again.
