import os
import base64

import boto3
from google.protobuf.json_format import MessageToDict

import message_pb2

QUEUE_URL = os.environ['QUEUE_URL']
SQS = boto3.client('sqs')

def consume(event, context):
    response = SQS.receive_message(
        QueueUrl=QUEUE_URL,
        MaxNumberOfMessages=1
    )

    message = response['Messages'][0]
    parsed_message = _parse(message['Body'])
    print(MessageToDict(parsed_message))

    SQS.delete_message(
        QueueUrl = QUEUE_URL,
        ReceiptHandle=message['ReceiptHandle']
    )

def _parse(message_string):
    byte_string = base64.b64decode(message_string)
    parsed_message = message_pb2.Message()
    parsed_message.ParseFromString(byte_string)

    return parsed_message
