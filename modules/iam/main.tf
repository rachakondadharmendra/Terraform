# Create an IAM role for the ECS service with an assume role policy.
resource "aws_iam_role" "ecs_service" {
  name = "ecs-service"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}


# Define an IAM policy document for granting permissions related to the Elastic Load Balancer (ELB).
data "aws_iam_policy_document" "ecs_service_elb" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:Describe*"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets"
    ]

    resources = [
      var.elb.arn
    ]
  }
}

# Define an IAM policy document for granting standard ECS-related permissions.
data "aws_iam_policy_document" "ecs_service_standard" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:DescribeTags",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:UpdateContainerInstancesState",
      "ecs:Submit*",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "*"
    ]
  }
}

# Define an IAM policy document for granting permissions related to ECS service scaling.
data "aws_iam_policy_document" "ecs_service_scaling" {
  statement {
    effect = "Allow"

    actions = [
      "application-autoscaling:*",
      "ecs:DescribeServices",
      "ecs:UpdateService",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:DescribeAlarmHistory",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:DescribeAlarmsForMetric",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DisableAlarmActions",
      "cloudwatch:EnableAlarmActions",
      "iam:CreateServiceLinkedRole",
      "sns:CreateTopic",
      "sns:Subscribe",
      "sns:Get*",
      "sns:List*"
    ]

    resources = [
      "*"
    ]
  }
}

# Define an IAM policy document for allowing ECS tasks to pull images from ECR.
data "aws_iam_policy_document" "ecr_pull_policy" {
  statement {
    effect = "Allow"

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:GetAuthorizationToken",
      "ecr:GetRegistryCatalogData",
      "ecr:BatchGetImage"
    ]

    resources = ["*"] 
  }
}

# Attach IAM policies to the ECS service role for Elastic Load Balancer access.
resource "aws_iam_policy" "ecs_service_elb" {
  name        = "ecs-service-elb-policy"
  path        = "/"
  description = "Allow access to the service ELB"

  policy = data.aws_iam_policy_document.ecs_service_elb.json
}

# Attach IAM policies to the ECS service role for standard ECS actions.
resource "aws_iam_policy" "ecs_service_standard" {
  name        = "ecs-service-standard-policy"
  path        = "/"
  description = "Allow standard ECS actions"

  policy = data.aws_iam_policy_document.ecs_service_standard.json
}

# Attach IAM policies to the ECS service role for ECS service scaling.
resource "aws_iam_policy" "ecs_service_scaling" {
  name        = "ecs-service-scaling-policy"
  path        = "/"
  description = "Allow ECS service scaling"

  policy = data.aws_iam_policy_document.ecs_service_scaling.json
}

# Attach IAM policies to the ECS service role for ECR image pull permissions.
resource "aws_iam_policy" "ecr_pull_policy" {
  name        = "ecr-pull-policy"
  path        = "/"
  description = "Allow ECS tasks to pull images from ECR"

  policy = data.aws_iam_policy_document.ecr_pull_policy.json
}

# Attach IAM policies to the ECS service role.
resource "aws_iam_role_policy_attachment" "ecs_service_elb" {
  role       = aws_iam_role.ecs_service.name
  policy_arn = aws_iam_policy.ecs_service_elb.arn
}

resource "aws_iam_role_policy_attachment" "ecs_service_standard" {
  role       = aws_iam_role.ecs_service.name
  policy_arn = aws_iam_policy.ecs_service_standard.arn
}

resource "aws_iam_role_policy_attachment" "ecs_service_scaling" {
  role       = aws_iam_role.ecs_service.name
  policy_arn = aws_iam_policy.ecs_service_scaling.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_ecr_pull" {
  role       = aws_iam_role.ecs_service.name
  policy_arn = aws_iam_policy.ecr_pull_policy.arn
}
