# Crear una subnet pública
resource "aws_subnet" "public_subnet" {
  vpc_id            = var.vpc_id   # Usamos la VPC creada o pasada como parámetro
  cidr_block        = "10.0.1.0/24"  # Rango de IPs de la subnet pública
  availability_zone = "eu-west-1a"   # Reemplaza con tu zona de disponibilidad
  map_public_ip_on_launch = true     # Asigna IPs públicas automáticamente

  tags = {
    Name = "public-subnet"
  }
}

# Crear una subnet privada
resource "aws_subnet" "private_subnet" {
  vpc_id            = var.vpc_id   # Usamos la misma VPC
  cidr_block        = "10.0.2.0/24"  # Rango de IPs de la subnet privada
  availability_zone = "eu-west-1b"   # Reemplaza con otra zona de disponibilidad

  tags = {
    Name = "private-subnet"
  }
}
