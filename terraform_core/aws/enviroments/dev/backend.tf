# infrastructure_core/aws/environments/shared/backend.tf
# Current local state configuration
# Note: When you're ready to migrate to S3:
# 1. Rename backend.tf.s3 to backend.tf
# 2. Configure the S3 bucket details
# 3. Run: terraform init -migrate-state

terraform {
  # Using local backend (this is the default)
  backend "local" {
    # By default, state file will be named 'terraform.tfstate'
    # and stored in the current directory
  }
}
