output "service_arn" {
  description = "ARN del servicio ECS"
  value       = aws_ecs_service.nginx_service.arn
}

output "task_definition_arn" {
  description = "ARN de la definición de la tarea ECS"
  value       = aws_ecs_task_definition.nginx_task.arn
}
