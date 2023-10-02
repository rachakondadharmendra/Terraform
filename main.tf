terraform {
  required_version = "~> 1.3"
/*
  backend "s3" {
    bucket         = locals.bucket_name
    key            = "micro_services_demo_tf_infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = locals.table_name
    encrypt        = true
  }
  
 */
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "vpc" {
  source = "./aws_vpc"  
  vpc_cidr = locals.vpc_cidr_number  
  az_count = locals.az_count_number            
}

module "ecs" {
  source = "./aws_ecs"  # Update with the correct path to your ECS module
  demo_app_cluster_name          = locals.cluster_name
  availability_zones             = module.vpc.availability_zones
  demo_app_task_family           = locals.demo_app_task_family
  ecr_repo_url                   = locals.ecr_repo_name
  container_port                 = locals.container_port_number
  demo_app_task_name             = locals.ecr_task_name
  ecs_task_execution_role_name   = locals.ecr_task_execution_role
  application_load_balancer_name = locals.application_load_balancer
  target_group_name              = locals.target_group_name_
  demo_app_service_name          = locals.ecs_service_app_name

}