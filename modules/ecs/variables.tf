variable "ecs_target_group" {
  description = "The ARN of the Elastic Load Balancing target group to associate with the ECS service."
}

variable "private_subnets" {
  description = "A list of private subnet IDs where the ECS service should be deployed."
  type        = list(string)
}

variable "ecs_task_sg" {}

variable "ecs_role" {
  description = "The IAM role to be used by the ECS tasks."
}

variable "container_image_url" {
  description = "URL of the container image in Amazon Elastic Container Registry (ECR) that the ECS tasks will use."
  type        = string
  default     = "987471316553.dkr.ecr.us-west-2.amazonaws.com/ecommerce_demo"
}

variable "container_image_tag" {
  description = "Tag of the container image in ECR that the ECS tasks will use."
  type        = string
  default     = "nginx_version"
}


variable "container_name" {
  description = "The name of the container where your application runs."
  type        = string
  default     = "ecommerce"
}

variable "container_port" {
  description = "The port on the container where your application is listening."
  type        = number
  default     = 80
}
