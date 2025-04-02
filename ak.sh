#!/bin/bash

AWS_REGION="ap-south-1"  # Change this to your AWS region

# Accept instance name as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <Instance-Name>"
    exit 1
fi

INSTANCE_NAME=$1

# Get the Instance ID of the instance with the given name
INSTANCE_ID=$(aws ec2 describe-instances \
    --region $AWS_REGION \
    --filters "Name=tag:Name,Values=$INSTANCE_NAME" "Name=instance-state-name,Values=running" \
    --query "Reservations[*].Instances[*].InstanceId" --output text)

if [ -z "$INSTANCE_ID" ]; then
    echo "No running instance found with name: $INSTANCE_NAME"
    exit 1
fi

# Terminate the instance
echo "Terminating instance: $INSTANCE_NAME (ID: $INSTANCE_ID)..."
aws ec2 terminate-instances --region $AWS_REGION --instance-ids $INSTANCE_ID

echo "Instance terminated successfully!"

