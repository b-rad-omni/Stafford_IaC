# Basic instance configuration
variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

# Network information (these will come from our VPC module)
variable "vpc_id" {
  description = "ID of the VPC where the instance will be created"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet where the instance will be created"
  type        = string
}

# Instance specifications
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"  # Free tier eligible instance type
}

# Amazon Linux 2 is a good choice for running Django
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = null  # We'll use a data source to find the latest Amazon Linux 2 AMI
}

# Key pair for SSH access
variable "key_name" {
  description = "Name of the SSH key pair to use for the instance"
  type        = string
}

