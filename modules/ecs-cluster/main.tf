resource "aws_ecs_cluster" "nginx_cluster" {
  name = var.cluster_name
}