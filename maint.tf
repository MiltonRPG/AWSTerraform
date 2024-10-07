provider "aws" {
  region = "us-east-1" # O cambia a tu región preferida
}

resource "aws_ecs_cluster" "nginx_cluster" {
  name = "nginx-cluster"
}
