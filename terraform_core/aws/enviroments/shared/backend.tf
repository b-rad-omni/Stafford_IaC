# infrastructure_core/aws/environments/shared/backend.tf.s3
# This is a template file for future S3 backend configuration
# Rename to backend.tf when ready to use S3 backend

terraform {
  backend "s3" {
    # bucket         = "your-terraform-state-bucket"
    # key            = "shared/terraform.tfstate"
    # region         = "us-east-1"
    # dynamodb_table = "terraform-state-lock"
  }
}