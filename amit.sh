#!/bin/bash

# Set AWS region
AWS_REGION="ap-south-1"

# Set EC2 parameters
AMI_ID="ami-0d682f26195e9ec0f"  # Replace with your AMI ID
INSTANCE_TYPE="t2.micro"
KEY_NAME="amit1"  # Replace with your Key Pair name
SECURITY_GROUP="sg-0bfbd83694612cbbd" # Replace with your Security Group name
SUBNET_ID="subnet-0da5fe1efd432d268"  # Replace with your Subnet ID
TAG_NAME="amit-cli-instance"
# Function to create an EC2 instance
create_instance() {
    echo "Creating EC2 instance..."
    INSTANCE_ID=$(aws ec2 run-instances \
        --image-id $AMI_ID \
        --instance-type $INSTANCE_TYPE \
        --key-name $KEY_NAME \
        --security-group-ids $SECURITY_GROUP \
        --subnet-id $SUBNET_ID \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$TAG_NAME}]" \
        --query "Instances[0].InstanceId" \
        --output text)

    echo "EC2 instance created with ID: $INSTANCE_ID"
    echo $INSTANCE_ID > instance_id.txt
}

# Function to terminate an EC2 instance
terminate_instance() {
    if [ ! -f instance_id.txt ]; then
        echo "No instance_id.txt file found. Unable to terminate instance."
        exit 1
    fi

    INSTANCE_ID=$(cat instance_id.txt)

    echo "Terminating EC2 instance: $INSTANCE_ID..."
    aws ec2 terminate-instances --instance-ids $INSTANCE_ID

    echo "EC2 instance terminated."
    rm -f instance_id.txt
}

# Menu options
echo "Choose an option:"
echo "1. Create EC2 instance"
echo "2. Terminate EC2 instance"
read -p "Enter your choice (1/2): " choice

case $choice in
    1) create_instance ;;
    2) terminate_instance ;;
    *) echo "Invalid choice. Exiting..." ;;
esac

