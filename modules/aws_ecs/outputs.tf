output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_demo_cluster.id
}

output "ecs_service_name" {
  value = aws_ecs_service.demo_app_service.name
}
