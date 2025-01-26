variable "project_name" {
  description = "Name of the project - used for resource naming and tagging"
  type        = string
}

variable "environment" {
  description = "Environment name (dev/staging/prod) - used for resource naming and tagging"
  type        = string
}

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default = {
    ManagedBy = "terraform"
  }
}