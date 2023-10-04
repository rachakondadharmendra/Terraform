output "ecs_cluster" {
  value = aws_ecs_cluster.ecommerce_demo_cluster
}

output "ecs_service" {
  value = aws_ecs_service.ecommerce_demo_service
}

