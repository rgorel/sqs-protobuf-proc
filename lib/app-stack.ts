import * as cdk from '@aws-cdk/core';
import * as lambda from '@aws-cdk/aws-lambda'
import * as sqs from '@aws-cdk/aws-sqs';

export class AppStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const queue = new sqs.Queue(this, 'TestQueue');

    const producer = new lambda.Function(this, 'testSqsProducerFunction', {
      runtime: lambda.Runtime.RUBY_2_7,
      code: new lambda.AssetCode('lambda/producer'),
      handler: 'producer.Producer.call',
      timeout: cdk.Duration.seconds(30),
      environment: {
        QUEUE_URL: queue.queueUrl
      }
    });

    const consumer = new lambda.Function(this, 'testSqsConsumerFunction', {
      runtime: lambda.Runtime.PYTHON_3_8,
      code: new lambda.AssetCode('lambda/consumer/package'),
      handler: 'consumer.consume',
      timeout: cdk.Duration.seconds(30),
      environment: {
        QUEUE_URL: queue.queueUrl
      }
    });

    queue.grantSendMessages(producer);
    queue.grantConsumeMessages(consumer);
  }
}
