

# echo "Starting the application"

# export AWS_ENDPOINT_URL=http://localhost:4566
# docker-compose -f localstack/localstack.yml up -d


# zip -r lambda_process.zip ../app/src/*
# tflocal init
tflocal apply -auto-approve

# echo "Application started"


echo "Sending messages to the queue"

for i in {1..100000}; do
    awslocal sqs send-message --queue-url http://sqs.us-east-1.localhost.localstack.cloud:4566/000000000000/process_queue --message-body "{ 'eventType': 'teste', 'data': 'teste' }"
done


# echo "Starting the tests"

# pytest ../app/tests

# echo "Tests finished"

# echo "Shutting down the application"

# tflocal destroy -auto-approve

# docker-compose -f ./localstack/localstack.yml down

# echo "Application shut down"