# Create an AWS Application Auto Scaling target for the ECS service to manage its desired count.
resource "aws_appautoscaling_target" "ecommerce_demo_target" {
  max_capacity       = 5
  min_capacity       = 1
  resource_id        = "service/${var.ecs_cluster.name}/${var.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Create an AWS Application Auto Scaling policy to scale based on memory utilization.
resource "aws_appautoscaling_policy" "ecommerce_demo_memory" {
  name               = "ecommerce-demo-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecommerce_demo_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecommerce_demo_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecommerce_demo_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = 80
  }
}

# Create an AWS Application Auto Scaling policy to scale based on CPU utilization.
resource "aws_appautoscaling_policy" "ecommerce_demo_cpu" {
  name               = "ecommerce-demo-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecommerce_demo_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecommerce_demo_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecommerce_demo_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60
  }
}
