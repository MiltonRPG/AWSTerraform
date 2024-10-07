# Crear una subnet pública
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.my_vpc.id  # Usamos el ID de la VPC creada
  cidr_block        = "10.0.1.0/24"      # Asigna un rango de IP para la subnet pública
  availability_zone = "eu-west-1a"       # Reemplaza con tu zona de disponibilidad preferida
  map_public_ip_on_launch = true         # Asigna IPs públicas automáticamente a las instancias

  tags = {
    Name = "public-subnet"
  }
}

# Crear una subnet privada
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.my_vpc.id  # Usamos el ID de la VPC creada
  cidr_block        = "10.0.2.0/24"      # Asigna un rango de IP para la subnet privada
  availability_zone = "eu-west-1b"       # Reemplaza con otra zona de disponibilidad

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"  # Rango de IPs que usará tu VPC
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "my-vpc"
  }
}


# Crear un grupo de seguridad para Nginx
resource "aws_security_group" "nginx_security_group" {
  vpc_id = aws_vpc.my_vpc.id  # Usamos la VPC que creamos anteriormente

  # Reglas de entrada (Inbound Rules)
  ingress {
    from_port   = 80                    # Puerto 80 para HTTP
    to_port     = 80                    # Mismo puerto
    protocol    = "tcp"                 # Protocolo TCP
    cidr_blocks = ["0.0.0.0/0"]         # Permitir tráfico desde cualquier lugar (puedes restringirlo si es necesario)
  }

  # Reglas de salida (Outbound Rules)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"                  # Todos los puertos
    cidr_blocks = ["0.0.0.0/0"]         # Permitir tráfico hacia cualquier lugar
  }

  tags = {
    Name = "nginx-security-group-milton"
  }
}
