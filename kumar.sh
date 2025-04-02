#!/bin/bash

# Set AWS region
AWS_REGION="ap-south-1"  # Change as needed

# Set EC2 parameters
AMI_ID="ami-0d682f26195e9ec0f"  # Replace with your AMI ID
INSTANCE_TYPE="t2.micro"
KEY_NAME="amit1"  # Replace with your Key Pair name
SECURITY_GROUP_ID="sg-0bfbd83694612cbbd"  # Replace with your Security Group ID
SUBNET_ID="subnet-0da5fe1efd432d268"  # Replace with your Subnet ID

# Accept instance name as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <Instance-Name>"
    exit 1
fi

INSTANCE_NAME=$1  # Use the given name

# Function to create an EC2 instance
create_instance() {
    echo "Creating EC2 instance with name: $INSTANCE_NAME ..."
    
    INSTANCE_ID=$(aws ec2 run-instances \
        --region $AWS_REGION \
        --image-id $AMI_ID \
        --instance-type $INSTANCE_TYPE \
        --key-name $KEY_NAME \
        --security-group-ids $SECURITY_GROUP_ID \
        --subnet-id $SUBNET_ID \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" \
        --query "Instances[0].InstanceId" \
        --output text)

    echo "EC2 instance created with ID: $INSTANCE_ID"
}

# Call the function
create_instance

