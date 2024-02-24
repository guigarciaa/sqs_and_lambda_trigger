# docker-compose -f localstack/localstack.yml up -d;


# echo "Starting the application"

# zip -r ./lambda_process.zip ../app/src/*.py

# tflocal init
# tflocal apply -auto-approve

# echo "Application started"

echo "Sending a message to the queue"

awslocal sqs send-message --queue-url http://sqs.us-east-1.localhost.localstack.cloud:4566/000000000000/process_queue --message-body "Hello World"

awslocal sqs send-message --queue-url http://sqs.us-east-1.localhost.localstack.cloud:4566/000000000000/terraform-example-queue.fifo --message-body "Hello World"

# echo "Starting the tests"

# pytest ../app/tests

# echo "Tests finished"

# echo "Shutting down the application"

# tflocal destroy -auto-approve

# docker-compose -f ./localstack/localstack.yml down

# echo "Application shut down"