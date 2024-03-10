provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  endpoints {
    lambda   = "http://localhost:4566"
    sns      = "http://localhost:4566"
    dynamodb = "http://localhost:4566"
    iam      = "http://localhost:4566"
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
    deadLetterTargetArn = aws_sqs_queue.process_queue_dlq.arn
    maxReceiveCount     = 3
  })
}

# Lambda Function
resource "aws_lambda_function" "lambda_core" {
  filename         = "lambda_process.zip"
  source_code_hash = filebase64sha256("lambda_process.zip")
  function_name    = "lambda_process"
  handler          = "lambda_process.lambda_handler"
  runtime          = "python3.8"
  role             = aws_iam_role.lambda_execution_role.arn
}

# Lambda SQS Queue Trigger
resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.process_queue.arn
  function_name    = aws_lambda_function.lambda_core.function_name
  batch_size       = 10
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_execution_policy_attachment" {
  name       = "lambda_execution_policy_attachment"
  roles      = [aws_iam_role.lambda_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "dynamodb_access_policy" {
  name = "dynamodb_access_policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ],
        "Resource" : "arn:aws:dynamodb:us-east-1:000000000000:table/tb_process"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "dynamodb_policy_attachment" {
  name       = "dynamodb_policy_attachment"
  roles      = [aws_iam_role.lambda_execution_role.name]
  policy_arn = aws_iam_policy.dynamodb_access_policy.arn
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
