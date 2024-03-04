# Sample Project - Using SQS with Lambda and RDS
This project is a sample project that demonstrates how to use AWS services suchjson as SQS, Lambda, and RDS. 

The project is a simple application that receives a message from an SQS queue, processes the message using a Lambda function, and then stores the message in an RDS database.

## Overview
<p align="center" width="100%">
    <img width="100%" src="./docs/overview.svg">
</p>

## Prerequisites
- Docker
- Python 3.8
- Pip

```bash
pip install awscli-local &&

pip install tflocal
```

## Setup
1. Clone the repository
2. Change directory to the project root
3. Run the following command to create the RDS database:
```bash