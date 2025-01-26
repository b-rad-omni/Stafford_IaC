provider "aws" {
  region = var.aws_region

  # Use default_tags to properly tag all resources
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = "prod" # Hardcoded for production
      ManagedBy   = "terraform"
    }
  }
}

# Now configure the production environment using the shared module
module "prod_environment" {
  source = "../shared"

  # Pass the required variables from shared module
  project_name = var.project_name
  aws_region   = var.aws_region
  environment = var.environment

  # Network configuration
  vpc_cidr           = "10.1.0.0/16" # Different from dev's 10.0.0.0/16
  availability_zones = ["us-east-1a", "us-east-1b"]

 

  # Instance configuration
  instance_type = "t2.micro"
  key_name      = "prod-key"
}