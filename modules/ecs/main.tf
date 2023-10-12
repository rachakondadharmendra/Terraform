# Create an Amazon ECS cluster
resource "aws_ecs_cluster" "ecommerce_demo_cluster" {
  name = "ecommerce-demo-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name    = "Ecommerce Demo Cluster"
    Project = "ecommerce-demo" 
  }
}

# Register Fargate capacity provider 
resource "aws_ecs_cluster_capacity_providers" "ecommerce_demo_cluster_providers" {
  cluster_name = aws_ecs_cluster.ecommerce_demo_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

# ECS task definition
resource "aws_ecs_task_definition" "ecommerce_demo_task" {
  family                   = "ecommerce-demo"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"] 
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = var.ecs_role.arn
  task_role_arn            = var.ecs_role.arn

  container_definitions = <<DEFINITION
[
  {
    "cpu": 512,
    "memory": 1024,
    "image": "${var.container_image_url}:${var.container_image_tag}",
    "name": "${var.container_name}",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
DEFINITION

  tags = {
    Name    = "Ecommerce Demo Task"
    Project = "ecommerce-demo"
  }
}

# ECS service
resource "aws_ecs_service" "ecommerce_demo_service" {
  name            = "ecommerce-demo-service"
  cluster         = aws_ecs_cluster.ecommerce_demo_cluster.id
  task_definition = aws_ecs_task_definition.ecommerce_demo_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.ecs_task_sg]
    assign_public_ip = true 
  }

  load_balancer {
    target_group_arn = var.ecs_target_group.arn
    container_name   = var.container_name
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  tags = {
    Name    = "Ecommerce Demo ECS Service"
    Project = "ecommerce-demo"
  }
}