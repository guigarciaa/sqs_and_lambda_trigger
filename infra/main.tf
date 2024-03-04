provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  endpoints {
    lambda = "http://localhost:4566"
    sns    = "http://localhost:4566"
    rds    = "http://localhost:4566"
    iam    = "http://localhost:4566"
  }
}

# SQS Dead Letter Queue (DLQ)
resource "aws_sqs_queue" "process_queue_dlq" {
  name = "dlq"
}


# SQS Queue
resource "aws_sqs_queue" "process_queue" {
  name = "process_queue"

   # Configure Redrive Policy to send messages to the DLQ after 3 failed attempts
  redrive_policy = jsonencode({
    deadLetterTargetArn    = aws_sqs_queue.process_queue_dlq.arn
    maxReceiveCount        = 3
  })
}

# Lambda Function
resource "aws_lambda_function" "lambda_core" {
  filename      = "lambda_process.zip"
  function_name = "lambda_process"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_process.lambda_handler"
  runtime       = "python3.8"
}

# Lambda SQS Queue Trigger
resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.process_queue.arn
  function_name    = aws_lambda_function.lambda_core.function_name
  batch_size       = 10
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow"
      }
    ]
  })
}

# IAM Policy Attachment for Lambda Role (Access to SQS)
resource "aws_iam_policy_attachment" "lambda_sqs_access" {
  name       = "lambda_sqs_access"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

# DynamoDB Table
resource "aws_dynamodb_table" "tb_process" {
  name         = "tb_process"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}
