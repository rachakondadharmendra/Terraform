resource "aws_codepipeline" "ecommerce_pipeline" {
  name = "ecommerce-pipeline"
  role_arn = var.cicd_codepipeline_role.arn

  artifact_store {
    location = var.s3_artifacts_bucket_name
    type = "S3"
  }

  stage {
    name = "Source"

    action {
      category = "Source"
      configuration = {
        "BranchName" = var.branches[var.env]
        "RepositoryName" = var.codecommit_repo_name
      }
      input_artifacts = []
      name = "Source"
      output_artifacts = [
        "SourceArtifact",
      ]
      owner = "AWS"
      provider = "CodeCommit"
      run_order = 1
      version = "1"
    }
  }

  stage {
    name = "Build"

    action {
      category = "Build"
      configuration = {
        "EnvironmentVariables" = jsonencode(
          [
            {
              name = "environment"
              type = "PLAINTEXT"
              value = var.env
            },
            {
              name = "REGION"
              type = "PLAINTEXT"
              value = var.region
            },
            {
              name = "AWS_ACCOUNT_ID"
              type = "PARAMETER_STORE"
              value = "MAIN_ACCOUNT_ID"
            },
            {
              name = "ECR_REPO_NAME"
              type = "PLAINTEXT"
              value = var.ecr_repo_name
            },
            {
              name = "IMAGE_TAG"
              type = "PLAINTEXT"
              value = "latest"
            },
            {
              name = "CONTAINER_NAME"
              type = "PLAINTEXT"
              value = var.container_name
            },
          ]
        )
        "ProjectName" = var.codebuild_name.name
      }
      input_artifacts = [
        "SourceArtifact",
      ]
      name = "Build"
      output_artifacts = [
        "BuildArtifact",
       ]
      owner = "AWS"
      provider = "CodeBuild"
      run_order = 1
      version = "1"
    }
  }

  stage {
    name = "Deploy"

    action {
      category = "Deploy"
      configuration = {
        "ClusterName" = var.cluster_name
        "ServiceName" = var.service_name
        "FileName" = var.json_artifactt_name
        "DeploymentTimeout" = "15"
      }
      input_artifacts = [
        "BuildArtifact",
      ]
      name = "Deploy"
      output_artifacts = []
      owner = "AWS"
      provider = "ECS"
      run_order = 1
      version = "1"
    }
  }
}

