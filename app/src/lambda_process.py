def lambda_handler(event, context):
    print(event, context)
    
    # Return a response
    reponse = {
        'statusCode': 200,
        'body': "Hello, World!"
    }

    return reponse
