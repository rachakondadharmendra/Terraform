# Create an Elastic Load Balancer (ELB) to distribute traffic to ECS instances.
resource "aws_lb" "elb" {
  name               = "load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [
    var.load_balancer_sg
  ]
  subnets            = var.public_subnets

  tags = {
    Name    = "Elastic Load Balancer"
    project = "ecommerce-demo"
  }
}

# Create an AWS Load Balancer Target Group for ECS instances.
resource "aws_lb_target_group" "ecs" {
  name        = "ecs"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc.id
  target_type = "ip"

  # Configure health checks for the target group.
  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = "200"
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  tags = {
    Name    = "Elastic Container Service"
    project = "ecommerce-demo"
  }
}

# Create an HTTP listener for the Elastic Load Balancer (ELB) to forward traffic to the ECS instances.
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.elb.arn
  port              = "80"
  protocol          = "HTTP"

  # Configure the default action to forward traffic to the ECS Target Group.
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs.arn
  }
}
