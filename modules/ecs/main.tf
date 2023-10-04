# Create an Amazon ECS cluster for the Ecommerce Demo application.
resource "aws_ecs_cluster" "ecommerce_demo_cluster" {
  name = "ecommerce-demo-cluster"
  capacity_providers = ["FARGATE"]

  # Enable container insights for monitoring.
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name    = "Ecommerce Demo Cluster"
    Project = "ecommerce-demo"
  }
}

# Define the task definition for the Ecommerce Demo application.
resource "aws_ecs_task_definition" "ecommerce_demo_task" {
  family = "ecommerce-demo"

  # Configure the container definition.
  container_definitions = <<TASK_DEFINITION
  [
    {
      "portMappings": [
        {
          "hostPort": 80,
          "protocol": "tcp",
          "containerPort": 80
        }
      ],
      "cpu": 512,
      "memory": 1024,
      "image" : "${var.container_image_url}:${var.container_image_tag}",
      "essential": true,
      "name": "site"
    }
  ]
  TASK_DEFINITION

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory                   = "1024"
  cpu                      = "512"
  execution_role_arn       = var.ecs_role.arn
  task_role_arn            = var.ecs_role.arn

  tags = {
    Name    = "Ecommerce Demo Task Definition"
    Project = "ecommerce-demo"
  }
}

# Create an Amazon ECS service for the Ecommerce Demo application.
resource "aws_ecs_service" "ecommerce_demo_service" {
  name        = "ecommerce-demo-service"
  cluster     = aws_ecs_cluster.ecommerce_demo_cluster.id
  task_definition = aws_ecs_task_definition.ecommerce_demo_task.arn
  desired_count  = 1
  launch_type    = "FARGATE"
  platform_version = "1.4.0"

  lifecycle {
    ignore_changes = [
      desired_count] # Allow external changes to happen without Terraform conflicts, particularly around auto-scaling.
  }

  network_configuration {
    subnets = var.private_subnets
    security_groups = [
      var.ecs_task_sg
    ]
    assign_public_ip = true
  }

  # Configure the load balancer settings.
  load_balancer {
    target_group_arn  = var.ecs_target_group.arn
    container_name    = "site"
    container_port    = var.container_port
  }

  tags = {
    Name    = "Ecommerce Demo ECS Service"
    Project = "ecommerce-demo"
  }
}
