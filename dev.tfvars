aws_region  = "us-east-1"

aws_az_pub = "us-east-1a"

aws_az_private = ["us-east-1b", "us-east-1c"]

vpc_cidr_block = "10.0.0.0/16"

public_subnet_cidr_blocks = ["10.0.1.0/24"]

private_subnet_cidr_blocks = ["10.0.101.0/24", "10.0.102.0/24"]

env = "dev"

vpc_name = "dev-vpc"

db_subnet_name = "dev-db-subnet"

igw_name = "dev-igw"

rt_name = "dev-rt"

pub_subnet_01 = "dev-pub-subnet-01"

priv_subnet_01 = "dev-priv-subnet-01"

priv_subnet_02 = "dev-priv-subnet-02"

sg_web_ssh = "dev-sg-web-ssh"

# ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20220609 ami-052efd3df9dad4825
ec2_web_ami = "ami-052efd3df9dad4825"

ec2_key_name = "rm-key"

rds_db_user = "foo"

rds_db_pass = "foobarbaz"

