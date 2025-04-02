import boto3
import sys
import time

# AWS Configuration (Update as needed)
REGION = "ap-south-1"  # Change if required
AMI_ID = "ami-0d682f26195e9ec0f"  # Replace with your AMI ID

def create_instances(instance_type, min_count, key_name):
    """Create EC2 instances and return their details."""
    ec2 = boto3.resource("ec2", region_name=REGION)

    print(f"Launching {min_count} EC2 instance(s) with type {instance_type} and key {key_name}...")

    instances = ec2.create_instances(
        ImageId=AMI_ID,
        InstanceType=instance_type,
        MinCount=int(min_count),
        MaxCount=int(min_count),
        KeyName=key_name
    )

    # Wait for instance to be running
    for instance in instances:
        instance.wait_until_running()
        instance.load()  # Refresh instance data

    return instances

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Usage: python3 script.py <InstanceType> <MinCount> <KeyName>")
        sys.exit(1)

    instance_type = sys.argv[1]
    min_count = sys.argv[2]
    key_name = sys.argv[3]

    instances = create_instances(instance_type, min_count, key_name)

    for instance in instances:
        print(f"EC2 Instance {instance.id} created successfully with Public IP: {instance.public_ip_address}")

