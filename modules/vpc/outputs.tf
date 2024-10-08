output "public_subnet_id" {
  description = "ID de la subnet pública"
  value       = aws_subnet.public_subnet.id
}

output "public_subnet_2_id" {
  value = aws_subnet.public_subnet_2.id
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

output "alb_security_group_id" {
  description = "El ID del grupo de seguridad para el ALB"
  value       = aws_security_group.alb_security_group.id
}