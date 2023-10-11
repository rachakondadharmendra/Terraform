terraform {
  backend "s3" {
    bucket         = "terraform-state-ecommerce"
    key            = "infra_plan/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-state-lock-ecommerce"
    encrypt        = true
  }
}