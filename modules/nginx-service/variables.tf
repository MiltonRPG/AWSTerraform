variable "cluster_id" {
  description = "ID del Cluster ECS donde se desplegará el servicio"
  type        = string
}

variable "task_family" {
  description = "Nombre de la familia de la tarea ECS"
  type        = string
  default     = "nginx-task"
}

variable "execution_role_arn" {
  description = "ARN del rol de ejecución para la tarea ECS"
  type        = string
}

variable "service_name" {
  description = "Nombre del servicio ECS"
  type        = string
  default     = "kc-nginx-service-milton"
}

variable "subnets" {
  description = "Lista de subnets para lanzar el servicio Fargate"
  type        = list(string)
}

variable "security_group_id" {
  description = "ID del Security Group para el servicio ECS"
  type        = string
}

variable "target_group_arn" {
  description = "ARN del Target Group del ALB"
  type        = string
}

variable "alb_security_group_id" {
  description = "ID del Security Group del ALB"
  type        = string
}
