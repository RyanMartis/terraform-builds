variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_az_pub" {
  description = "AWS AZs for public subnets"
  type        = string
}

variable "aws_az_private" {
  description = "AWS AZs for private subnets"
  type        = list
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidr_blocks" {
  description = "Available cidr blocks for private subnets"
  type        = list(string)
}

variable "env" {
  description = "app environment"
  type        = string
}

variable "vpc_name" {
  description = "vpc name"
  type        = string
}

variable "db_subnet_name" {
  description = "db subnet name"
  type        = string
}

variable "igw_name" {
  description = "igw name"
  type        = string
}

variable "rt_name" {
  description = "route table name"
  type        = string
}

variable "pub_subnet_01" {
  description = "public subnet"
  type        = string
}

variable "priv_subnet_01" {
  description = "private subnet"
  type        = string
}

variable "priv_subnet_02" {
  description = "private subnet"
  type        = string
}

variable "sg_web_ssh" {
  description = "security group for web and ssh"
  type        = string
}

variable "ec2_web_ami" {
  description = "ami for ec2 web servers"
  type        = string
}

variable "ec2_key_name" {
  description = "ec2 keypair in aws"
  type        = string
}

variable "rds_db_user" {
  description = "db username"
  type        = string
}

variable "rds_db_pass" {
  description = "db password"
  type = string
  sensitive = true
}

