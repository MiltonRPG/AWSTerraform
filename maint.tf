provider "aws" {
  region = "eu-west-1" # O cambia a tu región preferida
}

module "ecs_cluster" {
  source = "./modules/ecs-cluster"
  cluster_name = "kc-ecs-proyectofinal-milton"  # Puedes cambiar el nombre si lo deseas
}

module "nginx_service" {
  source            = "./modules/nginx-service"
  cluster_id        = module.ecs_cluster.cluster_id
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  subnets           = ["subnet-0123456789abcdef0"]  # Reemplaza con tus subnets
  security_group_id = "sg-0123456789abcdef0"        # Reemplaza con tu security group
}

module "network" {
  source  = "./modules/network"  # Ruta donde se encuentra el módulo network
  vpc_id  = "vpc-0123456789abcdef0"  # Reemplaza con el ID de tu VPC
}


resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}



