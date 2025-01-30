import boto3
import time

# Initialize AWS EC2 client
ec2_client = boto3.client('ec2')

# Function to create an EC2 instance
def create_instance():
    print("Launching EC2 instance...")
    response = ec2_client.run_instances(
        ImageId='ami-12345678',  # Replace with your AMI ID
        InstanceType='t2.micro',  # Instance type
        MinCount=1,
        MaxCount=1,
        KeyName='my-key-pair',  # Replace with your key pair
        SecurityGroupIds=['sg-0123456789abcdef0'],  # Replace with your security group
        SubnetId='subnet-0123456789abcdef0',  # Replace with your subnet ID
        TagSpecifications=[
            {
                'ResourceType': 'instance',
                'Tags': [{'Key': 'Name', 'Value': 'Auto-EC2-Instance'}]
            }
        ]
    )
    
    instance_id = response['Instances'][0]['InstanceId']
    print(f"Instance {instance_id} is launching...")

    # Wait until instance is running
    print("Waiting for instance to be in 'running' state...")
    waiter = ec2_client.get_waiter('instance_running')
    waiter.wait(InstanceIds=[instance_id])
    
    print(f"Instance {instance_id} is now running.")
    return instance_id

# Function to delete an EC2 instance
def delete_instance(instance_id):
    print(f"Terminating instance {instance_id}...")
    ec2_client.terminate_instances(InstanceIds=[instance_id])

    # Wait until instance is terminated
    print("Waiting for instance to be terminated...")
    waiter = ec2_client.get_waiter('instance_terminated')
    waiter.wait(InstanceIds=[instance_id])
    
    print(f"Instance {instance_id} has been terminated.")

# Main execution
if __name__ == "__main__":
    instance_id = create_instance()
    
    # Wait for some time before deleting
    print("Instance is running... waiting for 2 minutes before termination.")
    time.sleep(120)

    delete_instance(instance_id)
