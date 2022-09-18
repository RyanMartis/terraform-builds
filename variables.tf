variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets"
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

variable "sg_web_ssh" {
  description = "security group for web and ssh"
  type        = string
}

