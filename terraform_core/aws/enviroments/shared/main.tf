terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Create networking layer using the core networking module
module "networking" {
  source = "../../networking"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
}

# Create security layer using the core security module
module "security" {
  source = "../../security"
  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.networking.vpc_id
  
}

# Create EC2 instance using the reusable EC2 module
module "ec2_instance" {
  source = "../../../../terraform_modules/aws/ec2"

  project_name           = var.project_name
  environment            = var.environment
  instance_type          = var.instance_type
  subnet_id              = module.networking.public_subnet_ids[0]
  vpc_security_group_ids = [module.security.web_security_group_id]
  key_name               = var.key_name
}
