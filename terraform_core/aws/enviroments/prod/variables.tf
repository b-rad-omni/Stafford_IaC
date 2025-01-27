variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  
}

# Additional production-specific variables
variable "backup_retention_days" {
  description = "Number of days to retain backups"
  type        = number
  default     = 30
}

variable "enable_enhanced_monitoring" {
  description = "Enable enhanced monitoring for production resources"
  type        = bool
  default     = true
}

variable "environment" {
  type = string
  default = "prod"


}

variable "key_name" {
  type = string

}