aws_region = "us-east-1"

vpc_cidr_block = "10.0.0.0/16"

public_subnet_cidr_blocks = ["10.0.1.0/24"]

env = "dev"

vpc_name = "dev-vpc"

igw_name = "dev-igw"

rt_name = "dev-rt"

pub_subnet_01 = "dev-pub-subnet-01"

sg_web_ssh = "dev-sg-web-ssh"

# ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20220609 ami-052efd3df9dad4825
ec2_web_ami = "ami-052efd3df9dad4825"

ec2_key_name = "rm-key"

rds_db_user = "foo"

rds_db_pass = "foobarbaz"

