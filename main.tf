# Terraform Provider Config
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  profile       = "ryan-tf"
  region        = var.aws_region
}

# VPC
resource "aws_vpc" "dev-vpc-01" {
  cidr_block = var.vpc_cidr_block

  tags = {
    env = var.env
    Name = var.vpc_name
  }
}

# IGW
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.dev-vpc-01.id

    tags = {
      env = var.env
      Name = var.igw_name
    }
}

# Route Table
resource "aws_route_table" "dev-rt-01" {
    vpc_id = aws_vpc.dev-vpc-01.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }

    route {
        ipv6_cidr_block     = "::/0"
        gateway_id          = aws_internet_gateway.gw.id
    }

    tags = {
        env = var.env
        env = var.rt_name
    }
}

# Public Subnet
resource "aws_subnet" "dev-pub-subnet-01" {
  vpc_id        = aws_vpc.dev-vpc-01.id
  cidr_block    = var.public_subnet_cidr_blocks[0]

  tags = {
      env  = var.env
      Name = var.pub_subnet_01 
  }
}
  
# Associate Subnet with Route Table
resource "aws_route_table_association" "association-01" {
    subnet_id       = aws_subnet.dev-pub-subnet-01.id
    route_table_id  = aws_route_table.dev-rt-01.id
}

# Create Security Group (SSH, HTTP)
resource "aws_security_group" "web_ssh" {
    name        = "allow_web_ssh_traffic"
    description = "Allow inbound ssh and web traffic"
    vpc_id      = aws_vpc.dev-vpc-01.id

    ingress {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        env   = var.env
        Name  = var.sg_web_ssh 
    }
}

# Network Interface for EIP (AWS ENI)
resource "aws_network_interface" "dev-eni-01" {
    subnet_id       = aws_subnet.dev-pub-subnet-01.id
    private_ips     = ["10.0.1.4"] # first non reserved IP
    security_groups = [aws_security_group.web_ssh.id]

    tags = {
        env   = var.env
    }
}

# EIP assignment to ENI
resource "aws_eip" "eip-01" {
    vpc                         = true
    network_interface           = aws_network_interface.dev-eni-01.id
    associate_with_private_ip   = "10.0.1.4"
    depends_on                  = [aws_internet_gateway.gw]

    tags = {
        env = var.env
    }
}




