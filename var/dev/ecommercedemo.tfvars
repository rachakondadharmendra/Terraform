region              = "us-west-2"
s3_bucket_name      = "terraform-state-ecommerce"
dynamodb_table_name = "terraform-state-lock-ecommerce"
container_image_url = "987471316553.dkr.ecr.us-west-2.amazonaws.com/ecommerce_demo"
container_image_tag = "nginx_version"
container_name      = "ecommerce"
container_port      = 80

