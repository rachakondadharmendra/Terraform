variable "s3_bucket_name" {
  description = "Name of the remote S3 bucket"
  type        = string
  validation {
    condition     = can(regex("^([a-z0-9]{1}[a-z0-9-]{1,61}[a-z0-9]{1})$", var.s3_bucket_name))
    error_message = "S3 Bucket Name must follow naming rules: lowercase alphanumeric characters and hyphens, and must not be empty."
  }
}
