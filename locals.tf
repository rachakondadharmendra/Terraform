locals {
  bucket_name = "micro_services_demo_tf_state_bucket"
  table_name  = "micro_services_demo_tf_state_table"
  vpc_cidr_number = "10.0.0.0/16" 
  az_count = "2"
  cluster_name = "ecr_ecommerce_demo
  demo_app_task_family = "ecs_demo_tasks"
  ecr_repo_name = "987471316553.dkr.ecr.us-east-2.amazonaws.com/ecommerce_demo"
  container_port_number = 80
  ecr_task_name = " ecr-task"
  ecr_task_execution_role ="ecr-execution-role"
  application_load_balancer = "ecr-abl" 
  target_group_name_ = "ecr-target-group"
  ecs_service_app_name = "ecommerce-demo-app "

}