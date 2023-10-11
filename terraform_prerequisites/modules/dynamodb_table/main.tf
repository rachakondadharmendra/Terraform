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
