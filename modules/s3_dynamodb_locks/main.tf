# Create an S3 bucket for Terraform state storage with force destroy enabled.
resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket        = var.s3_bucket_name
  force_destroy = true

  lifecycle {
    prevent_destroy = true
  }  
}

# Enable versioning for the Terraform state S3 bucket.
resource "aws_s3_bucket_versioning" "terraform_state_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure server-side encryption for the Terraform state S3 bucket using AES256.
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_bucket_encrypt" {
  bucket = aws_s3_bucket.terraform_state_bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Create a DynamoDB table for Terraform locks with Pay-Per-Request billing mode.
resource "aws_dynamodb_table" "terraform_locks_table" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
