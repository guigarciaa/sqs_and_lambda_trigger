import boto3

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('tb_process')

    # Print the event data
    print(f'Event recevided: {event}')

    try:
        # Insert a new record
        table.put_item(
        Item={
            'id': range(1, 1000),
            'name': f'Process {range(1, 1000)}',
            'status': 'Running'
        })

        print('Record inserted')
        return {
            'statusCode': 200,
            'body': "Record inserted"
        }
    except Exception as e:
        print(e)
        return {
            'statusCode': 500,
            'body': "Error inserting record"
        }