output "prod_instance_public_ip" {
  description = "Public IP of the production instance"
  value       = module.prod_environment.instance_public_ip
}

output "prod_instance_private_ip" {
  description = "Private IP of the production instance"
  value       = module.prod_environment.instance_private_ip
}

output "prod_vpc_id" {
  description = "ID of the production VPC"
  value       = module.prod_environment.vpc_id
}