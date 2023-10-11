terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
/*
module "s3_dynamodb_locks" {
  source      = "../../../modules/s3_dynamodb_locks"
  s3_bucket_name = var.s3_bucket_name
  dynamodb_table_name  = var.dynamodb_table_name
}


module "ecr" {
  source   = "../../../modules/ecr"
  ecr_repo = "ecommerce_demo"

}
*/

module "vpc" {
  source = "../../../modules/vpc"
}

module "elb" {
  source           = "../../../modules/elb"
  load_balancer_sg = module.vpc.load_balancer_security_group
  public_subnets   = module.vpc.public_subnets
  vpc              = module.vpc.vpc
}

module "iam" {
  source = "../../../modules/iam"
  elb    = module.elb.elb
}

module "ecs" {
  source              = "../../../modules/ecs"
  ecs_role            = module.iam.ecs_role
  ecs_task_sg         = module.vpc.ecs_task_sg
  private_subnets     = module.vpc.private_subnets
  ecs_target_group    = module.elb.ecs_target_group
  container_image_url = var.container_image_url
  container_image_tag = var.container_image_tag
  container_name      = var.container_name
  container_port      = var.container_port

}

module "auto_scaling" {
  source      = "../../../modules/auto-scaling"
  ecs_cluster = module.ecs.ecs_cluster
  ecs_service = module.ecs.ecs_service
}
