variable "env" {
  description = "The environment to deploy to, such as `dev`, `stage`, or `prod`."
  type        = string
  default     = "dev"
}

variable "cicd_codepipeline_role" {
  description = "The IAM role to be used by the codepipeline."
}

variable "branches" {
  description = "A map of branch names for each environment."
  type        = map(string)
  default     = {
    dev   = "dev"
    stage = "stage"
    prod  = "main"
  }
}

variable "codecommit_repo_name" {
  type        = string
  default     = "ecommerce_demo_via_nginx"
}

variable "ecr_repo_name" {
  type        = string
  default     = "ecommerce_demo"
}

variable "region" {
  type        = string
  description = "The region you want to deploy the infrastructure in"
  default     = "us-west-2"
}

variable "s3_artifacts_bucket_name" {
  type        = string
  description = "The name of the S3 bucket for Terraform state storage."
  default     = "terraform-state-ecommerce"
}

variable "container_name" {
  description = "The name of the container where your application runs."
  type        = string
  default     = "ecommerce"
}
variable "codebuild_name" {}


variable "cluster_name" {
  type        = string
  default     = "ecommerce-demo-cluster"
}

variable "service_name" {
  type        = string
  default     = "ecommerce-demo-service"
}

variable "json_artifactt_name" {
  type        = string
  default     = "ecommerce_artifact.json"
}