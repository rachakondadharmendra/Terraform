variable "env" {
  description = "The environment to deploy to, such as `dev`, `stage`, or `prod`."
  type        = string
  default     = "dev"
}

variable "cicd_build_role" {
  description = "The IAM role to be used by the codebuild to execute builds."
}

variable "codebuild_name" {
  description = "A map of codebuild names for each environment."
  type = map(string)
  default = {
    dev = "ecommerce-codebuild-dev"
    stage = "ecommerce-codebuild-stage"
    prod = "ecommerce-codebuild-prod"
  }
}