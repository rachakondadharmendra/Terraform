resource "aws_codebuild_project" "ecommerce_codebuild" {
  badge_enabled  = false
  build_timeout  = 30
  name           = var.codebuild_name[var.env]
  queued_timeout = 360
  service_role   = var.cicd_build_role.arn
  tags = {
    Environment = var.env
    project = "ecommerce-demo"

  }

  artifacts {
    encryption_disabled = false
    packaging = "NONE"
    type      = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
    git_clone_depth     = 0
    type                = "CODEPIPELINE"
  }
}