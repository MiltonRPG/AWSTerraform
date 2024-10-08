# Crear una VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"  # Rango de IPs que usará tu VPC
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "my-vpc"
  }
}

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

# Crear una segunda subnet pública
resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.3.0/24"       # Asigna un rango de IP para la segunda subnet pública
  availability_zone = "eu-west-1b"        # Otra zona de disponibilidad
  map_public_ip_on_launch = true          # Asignar IPs públicas automáticamente

  tags = {
    Name = "public-subnet-2"
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

# Crear una Internet Gateway para la subnet pública
resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id  # Asociar la Internet Gateway a la VPC

  tags = {
    Name = "my-internet-gateway"
  }
}

# Crear una tabla de ruteo para la subnet pública
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_internet_gateway.id  # Dirigir tráfico a la Internet Gateway
  }

  tags = {
    Name = "public-route-table"
  }
}

# Asociar la subnet pública a la tabla de ruteo pública
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Crear una Elastic IP para el NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"  # En lugar de vpc = true, usamos domain = "vpc"
}

# Crear un NAT Gateway para la subnet privada
resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id  # El NAT Gateway debe estar en una subnet pública

  tags = {
    Name = "my-nat-gateway"
  }
}

# Crear una tabla de ruteo para la subnet privada
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat_gateway.id  # Dirigir tráfico de la subnet privada al NAT Gateway
  }

  tags = {
    Name = "private-route-table"
  }
}

# Asociar la subnet privada a la tabla de ruteo privada
resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

# Crear un grupo de seguridad para Nginx
resource "aws_security_group" "nginx_security_group" {
  vpc_id = aws_vpc.my_vpc.id  # Usamos la VPC que creamos anteriormente

  # Reglas de entrada (Inbound Rules)
  ingress {
    from_port   = 80                    # Puerto 80 para HTTP
    to_port     = 80                    # Mismo puerto
    protocol    = "tcp"                 # Protocolo TCP
    cidr_blocks = ["0.0.0.0/0"]         # Permitir tráfico desde cualquier lugar
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

