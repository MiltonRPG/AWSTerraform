output "cluster_id" {
  description = "ID del Cluster ECS creado"
  value       = aws_ecs_cluster.nginx_cluster.id
}