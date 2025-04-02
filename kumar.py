import boto3
import sys
import time

# AWS Configuration (Ensure AWS credentials are set up in ~/.aws/credentials)
REGION = "ap-south-1"  # Change as needed
AMI_ID = "ami-0d682f26195e9ec0f"  # Amazon Linux 2 AMI ID (Change for your OS)
INSTANCE_TYPE = "t2.micro"  # Change based on your requirements

def create_instances(count=3):
    """Create EC2 instances and return their instance IDs."""
    ec2 = boto3.client("ec2", region_name=REGION)
    
    print(f"Creating {count} EC2 instances...")
    response = ec2.run_instances(
        ImageId=AMI_ID,
        InstanceType=INSTANCE_TYPE,
        MinCount=count,
        MaxCount=count
    )
    
    instance_ids = [instance["InstanceId"] for instance in response["Instances"]]
    print("Instances created:", instance_ids)
    return instance_ids

def terminate_instances(instance_ids):
    """Terminate EC2 instances."""
    ec2 = boto3.client("ec2", region_name=REGION)
    print(f"Terminating instances: {instance_ids}")
    ec2.terminate_instances(InstanceIds=instance_ids)
    print("Instances terminated.")

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Usage: python3 script.py <arg1> <arg2> <arg3>")
        sys.exit(1)

    args = sys.argv[1:4]
    print("Arguments received:", args)

    # Create instances
    instances = create_instances()

    # Wait before terminating
    time.sleep(30)  # Wait 30 seconds before deleting

    # Terminate instances
    terminate_instances(instances)

