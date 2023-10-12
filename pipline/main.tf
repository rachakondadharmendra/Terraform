terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


module "iam-pipeline" {
  source = "./modules/iam-pipeline"
}

module "code-pipeline" {
  source = "./modules/code-pipeline"

  cicd_codepipeline_role = module.iam-pipeline.cicd_codepipeline_role
  codebuild_name = module.codebuild.codebuild_name
}


module "codebuild" {
  source = "./modules/codebuild"
  cicd_build_role = module.iam-pipeline.cicd_build_role
}

