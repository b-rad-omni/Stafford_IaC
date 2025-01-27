output "instance_id" {
  description = "ID of the created EC2 instance"
  value       = aws_instance.django.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.django.public_ip
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.ec2.id
}