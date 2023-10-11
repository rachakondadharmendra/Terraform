terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "s3" {
  source         = "./modules/s3"
  s3_bucket_name = var.s3_bucket_name
}

module "dynamodb_table" {
  source              = "./modules/dynamodb_table"
  dynamodb_table_name = var.dynamodb_table_name
}

/*
module "ecr" {
  source   = "./modules/ecr"
  ecr_repo = var.ecr_repo_name
}
*/