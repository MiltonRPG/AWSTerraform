provider "aws" {
  region = "eu-west-1" # O cambia a tu región preferida
}

module "ecs_cluster" {
  source = "./modules/ecs-cluster"
  cluster_name = "nginx-cluster"  # Puedes cambiar el nombre si lo deseas
}
