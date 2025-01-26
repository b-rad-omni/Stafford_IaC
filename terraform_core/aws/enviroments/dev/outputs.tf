output "dev_instance_public_ip" {
  description = "Public IP of the development instance"
  value       = module.dev_environment.instance_public_ip
}

output "dev_instance_private_ip" {
  description = "Private IP of the development instance"
  value       = module.dev_environment.instance_private_ip
}