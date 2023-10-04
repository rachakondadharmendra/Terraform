# Create an Amazon Elastic Container Registry (ECR) repository to store container images.
resource "aws_ecr_repository" "ecr_repository" {
  name                 = var.ecr_repo  
  image_tag_mutability = "IMMUTABLE"   

# Configure image scanning to scan images automatically when pushed.
  image_scanning_configuration {
    scan_on_push = true
  }
}
