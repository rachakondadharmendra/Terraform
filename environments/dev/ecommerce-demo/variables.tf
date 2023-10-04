variable "region" {
  type        = string
  description = "The region you want to deploy the infrastructure in"
  default     = "us-west-2"
}

variable "s3_bucket_name" {
  type        = string
  description = "The name of the S3 bucket for Terraform state storage."
  default     = "terraform-state-ecommerce"
}

variable "dynamodb_table_name" {
  type        = string
  description = "The name of the DynamoDB table for Terraform locks."
  default     = "terraform-state-lock-ecommerce"
}

variable "container_image_url" {
  type        = string
  description = "URL of the container image in ECR."
  default     = "987471316553.dkr.ecr.us-west-2.amazonaws.com/ecommerce_demo"
}

variable "container_image_tag" {
  type        = string
  description = "Tag of the container image in ECR."
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

variable "s3_backend_key" {
  type        = string
  description = "The key for the Terraform state file in the S3 bucket."
  default     = "terraform_setup/terraform.tfstate"
}
