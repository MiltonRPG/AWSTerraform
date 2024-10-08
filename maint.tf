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
  subnets           = [module.vpc.private_subnet_id]  # Usamos las subnets que acabamos de crear
  security_group_id = module.vpc.nginx_security_group_id  # Usamos el grupo de seguridad creado
  alb_security_group_id = module.vpc.alb_security_group_id
  service_name       = "kc-nginx-service-milton"       # Nombre del servicio
  task_family        = "nginx-task-family"  
  target_group_arn   = aws_lb_target_group.nginx_target_group.arn           # Familia de tareas
}


module "vpc" {
  source = "./modules/vpc"  # Cambia la ruta al módulo vpc
  # Otras variables que pases al módulo
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

# Crear un Application Load Balancer (ALB)
resource "aws_lb" "nginx_alb" {
  name               = "nginx-alb-milton"
  internal           = false  # El ALB será público (accesible desde Internet)
  load_balancer_type = "application"
  
  security_groups    = [module.vpc.alb_security_group_id]
  subnets            = [module.vpc.public_subnet_id, module.vpc.public_subnet_2_id]  # El ALB debe estar en la subnet pública

  enable_deletion_protection = false  # No proteger el ALB de eliminaciones
  tags = {
    Name = "nginx-alb"
  }
}


# Listener para el ALB en el puerto 80
resource "aws_lb_listener" "nginx_listener" {
  load_balancer_arn = aws_lb.nginx_alb.arn  # Conectar el listener al ALB
  port              = 80                    # Escuchar en el puerto 80 (HTTP)
  protocol          = "HTTP"                # Protocolo HTTP

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.nginx_target_group.arn  # Redirigir el tráfico al target group
  }
}


# Target Group para ECS
resource "aws_lb_target_group" "nginx_target_group" {
  name     = "nginx-target-group-milton"
  port     = 80                      # Recibe tráfico en el puerto 80
  protocol = "HTTP"                  # Protocolo HTTP
  vpc_id   = module.vpc.vpc_id       # Asociamos el Target Group con la VPC

  target_type = "ip"  # Cambiar a IP

  health_check {
    path     = "/"                   # Verificación de salud en la raíz "/"
    protocol = "HTTP"
    port     = "80"
  }
}

/*
# Asociar la tarea de ECS con el Target Group
resource "aws_lb_target_group_attachment" "nginx_target_attachment" {
  target_group_arn = aws_lb_target_group.nginx_target_group.arn  # Usar el ARN del Target Group que creamos
  target_id        = ws_ecs_service.nginx_service.id          # Asociar con el servicio ECS
  port             = 80                                          # Enrutar el tráfico al puerto 80 de las tareas
}
*/


