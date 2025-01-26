module "dev_environment" {
  source = "./shared"

  # Environment information
  environment  = "dev"
  project_name = "stafford-solutions"
  aws_region   = "us-east-1"

  # Network configuration
  vpc_cidr            = "10.0.0.0/16"
  availability_zones  = ["us-east-1a", "us-east-1b"]

  # Security configuration
  allowed_ssh_cidrs   = ["0.0.0.0/0"]  # Should be restricted in production

  # Instance configuration
  instance_type       = "t2.micro"
  key_name           = "dev-key"  # Make sure this key pair exists in AWS
}

# infrastructure_core/aws/environments/dev/outputs.tf

output "dev_instance_public_ip" {
  description = "Public IP of the development instance"
  value       = module.dev_environment.instance_public_ip
}