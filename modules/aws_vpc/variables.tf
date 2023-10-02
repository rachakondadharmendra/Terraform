variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"  # You can change the default CIDR block as needed
}

variable "az_count" {
  type    = number
  default = 3  # You can change the number of availability zones as needed
}
