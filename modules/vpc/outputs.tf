output "public_subnet_id" {
  description = "ID de la subnet pública"
  value       = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  description = "ID de la subnet privada"
  value       = aws_subnet.private_subnet.id
}
