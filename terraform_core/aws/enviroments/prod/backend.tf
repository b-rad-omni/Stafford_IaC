# infrastructure_core/aws/environments/prod/backend.tf.s3
# Template for future S3 backend configuration
# This file serves as a template for when you're ready to migrate to remote state storage
# To use it, rename it to backend.tf and configure the bucket details

terraform {
  backend "s3" {
     bucket         = "stafford_terraform_states"
     key            = "shared/terraform.tfstate"
     region         = "us-east-1"
    
  }
}