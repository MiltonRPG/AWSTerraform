output "public_subnet_id" {
  description = "ID de la subnet pública"
  value       = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  description = "ID de la subnet privada"
  value       = aws_subnet.private_subnet.id
}

output "vpc_id" {
  description = "El ID de la VPC creada"
  value       = aws_vpc.my_vpc.id
}

output "nginx_security_group_id" {
  description = "El ID del grupo de seguridad para nginx"
  value       = aws_security_group.nginx_security_group.id
}