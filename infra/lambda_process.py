def lambda_handler(event, context):
    # event: Event data passed to the Lambda function
    # context: Runtime information about the Lambda function

    # Print "Hello, World!" to CloudWatch Logs
    print("Hello, World!")

    # Return a response
    return {
        'statusCode': 200,
        'body': 'Hello, World!'
    }


# Invoke the lambda_handler function
response = lambda_handler({}, None) 
print(response)  # Output: {'statusCode': 200, 'body': 'Hello, World!'}