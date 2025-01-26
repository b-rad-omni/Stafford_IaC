# Current local state configuration
# This file manages how Terraform stores its state during development

terraform {
  # Using local backend (this is the default)
  backend "local" {
    # State will be stored in terraform.tfstate in the current directory
  }
}