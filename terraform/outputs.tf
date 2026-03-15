output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main_vpc.id
}

output "public_subnet_id" {
  description = "Public subnet ID"
  value       = aws_subnet.public_subnet.id
}

output "instance_public_ip" {
  description = "Public IP of EC2 instance"
  value       = "http://${aws_instance.web_server.public_ip}"
}

output "instance_public_dns" {
  description = "Public DNS of EC2 instance"
  value       = aws_instance.web_server.public_dns
}