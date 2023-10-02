output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ecs_cluster_id" {
  value = module.ecs.ecs_cluster_id
}

output "ecs_service_name" {
  value = module.ecs.ecs_service_name
}