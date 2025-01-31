#######################################################################################################

import boto3

ec2_client = boto3.client('ec2')

response = ec2_client.run_instances(
    KeyName='my-keypair',
    InstanceType='t2.micro',
    ImageId='ami-0c55b159cbfafe1f0',  # Amazon Linux 2 AMI
    MinCount=1,
    MaxCount=1,
    TagSpecifications=[
        {
            'ResourceType': 'instance',
            'Tags': [{'Key': 'Name', 'Value': 'example-instance'}]
        }
    ]
)

instance_id = response['Instances'][0]['InstanceId']
print(f'EC2 Instance Created: {instance_id}')

##############################################################################################

import boto3

s3_client = boto3.client('s3')

bucket_name = 'my-unique-bucket-name-12345'  # Replace with a unique name
s3_client.create_bucket(Bucket=bucket_name, CreateBucketConfiguration={'LocationConstraint': 'us-east-1'})

print(f'S3 Bucket Created: {bucket_name}')

##############################################################################################


import boto3

ec2_client = boto3.client('ec2')

# Create VPC
vpc_response = ec2_client.create_vpc(CidrBlock='10.0.0.0/16')
vpc_id = vpc_response['Vpc']['VpcId']
print(f'Created VPC: {vpc_id}')

# Create Public Subnet
public_subnet_response = ec2_client.create_subnet(VpcId=vpc_id, CidrBlock='10.0.1.0/24', AvailabilityZone='us-east-1a')
public_subnet_id = public_subnet_response['Subnet']['SubnetId']
print(f'Created Public Subnet: {public_subnet_id}')

# Create Private Subnet
private_subnet_response = ec2_client.create_subnet(VpcId=vpc_id, CidrBlock='10.0.2.0/24', AvailabilityZone='us-east-1a')
private_subnet_id = private_subnet_response['Subnet']['SubnetId']
print(f'Created Private Subnet: {private_subnet_id}')


###############################################################################################


import boto3

ec2_client = boto3.client('ec2')
asg_client = boto3.client('autoscaling')
elb_client = boto3.client('elbv2')

# Create Launch Configuration
asg_client.create_launch_configuration(
    LaunchConfigurationName='example-launch-config',
    ImageId='ami-0c55b159cbfafe1f0',
    InstanceType='t2.micro',
    SecurityGroups=['sg-12345678'],  # Replace with security group ID
    UserData='''#!/bin/bash
    echo "Hello, World!" > index.html
    nohup python -m SimpleHTTPServer 80 &
    '''
)

print("Launch Configuration Created")

# Create Auto Scaling Group
asg_client.create_auto_scaling_group(
    AutoScalingGroupName='example-asg',
    LaunchConfigurationName='example-launch-config',
    MinSize=1,
    MaxSize=3,
    DesiredCapacity=2,
    VPCZoneIdentifier='subnet-12345678'  # Replace with subnet ID
)

print("Auto Scaling Group Created")

# Create Load Balancer
alb_response = elb_client.create_load_balancer(
    Name='example-lb',
    Subnets=['subnet-12345678'],  # Replace with subnet IDs
    SecurityGroups=['sg-12345678'],  # Replace with security group ID
    Scheme='internet-facing',
    Type='application'
)

alb_arn = alb_response['LoadBalancers'][0]['LoadBalancerArn']
print(f'Application Load Balancer Created: {alb_arn}')

# Create Target Group
tg_response = elb_client.create_target_group(
    Name='example-tg',
    Protocol='HTTP',
    Port=80,
    VpcId='vpc-12345678'  # Replace with VPC ID
)

tg_arn = tg_response['TargetGroups'][0]['TargetGroupArn']
print(f'Target Group Created: {tg_arn}')


##########################################################################################

