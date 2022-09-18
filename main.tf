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
resource "aws_subnet" "pub-subnet-01" {
  vpc_id            = aws_vpc.dev-vpc-01.id
  cidr_block        = var.public_subnet_cidr_blocks[0]
  availability_zone = var.aws_az_pub

  tags = {
      env  = var.env
      Name = var.pub_subnet_01 
  }
}

# Private Subnet
resource "aws_subnet" "priv-subnet-01" {
  vpc_id            = aws_vpc.dev-vpc-01.id
  cidr_block        = var.private_subnet_cidr_blocks[0]
  availability_zone = var.aws_az_private[0] 

  tags = {
      env  = var.env
      Name = var.priv_subnet_01 
  }
}

# Private Subnet 2
resource "aws_subnet" "priv-subnet-02" {
  vpc_id            = aws_vpc.dev-vpc-01.id
  cidr_block        = var.private_subnet_cidr_blocks[1]
  availability_zone = var.aws_az_private[1] 

  tags = {
      env  = var.env
      Name = var.priv_subnet_02 
  }
}

  
# Associate Subnet with Route Table
resource "aws_route_table_association" "association-01" {
    subnet_id       = aws_subnet.pub-subnet-01.id
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

# ubuntu server w/nginx
resource "aws_instance" "web_server" {
  ami               = var.ec2_web_ami 
  instance_type     = "t2.micro"
  availability_zone = var.aws_az_pub
  key_name          = var.ec2_key_name
  #subnet_id         = aws_subnet.pub-subnet-01.id

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web-server-nic.id
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install nginx -y
              sudo apt install postgresql-client-14 -y
              sudo systemctl start nginx
              sudo rm -rf /var/www/html/index.nginx-debian.html
              sudo bash -c 'echo Ryan NGINX Server > /var/www/html/index.nginx-debian.html'
              EOF

  tags = {
    Name = "nginx server"
  }
}

# Network Interface for EIP (AWS ENI)
resource "aws_network_interface" "web-server-nic" {
    subnet_id         = aws_subnet.pub-subnet-01.id
    private_ips       = ["10.0.1.4"] # first non reserved IP
    security_groups   = [aws_security_group.web_ssh.id]

    tags = {
        env   = var.env
    }
}

# EIP assignment to ENI
resource "aws_eip" "eip-01" {
    vpc                         = true
    network_interface           = aws_network_interface.web-server-nic.id
    associate_with_private_ip   = "10.0.1.4"
    depends_on                  = [aws_internet_gateway.gw]

    tags = {
        env = var.env
    }
}

# EBS volume
resource "aws_ebs_volume" "ec2-volume" {
  availability_zone = var.aws_az_pub
  size              = 1
}

# EBS attach volume
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ec2-volume.id
  instance_id = aws_instance.web_server.id
}

# RDS Security Group
resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Postgres DB Security Group"
  vpc_id      = aws_vpc.dev-vpc-01.id

  ingress {
    description       = "Allow PSQL traffic from web_ssh sg"
    from_port         = "5432"
    to_port           = "5432"
    protocol          = "tcp"
    security_groups   = [aws_security_group.web_ssh.id]
  }

  tags = {
    env = var.env
    Name = "DB-SG"
  }
}

# RDS DB subnet group
resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.priv-subnet-01.id, aws_subnet.priv-subnet-02.id]

  tags = {
      env   = var.env
      Name  = var.db_subnet_name 
  }
}

# RDS

resource "aws_db_instance" "pg-db" {
  allocated_storage       = 10
  db_name                 = "Ryan"
  engine                  = "postgres"
  engine_version          = "14.4"
  instance_class          = "db.t3.micro"
  username                = var.rds_db_user
  password                = var.rds_db_pass
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.default.id
  vpc_security_group_ids  = [aws_security_group.db_sg.id]

  tags = {
    Name = "postgres rds"
  }
}


