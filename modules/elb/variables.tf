variable "load_balancer_sg" {
  description = "The security group ID(s) to associate with the Elastic Load Balancer (ELB)."
}

variable "public_subnets" {
  description = "A list of public subnet IDs where the Elastic Load Balancer (ELB) will be deployed."
  type        = list(string)
}

variable "vpc" {
  description = "The Virtual Private Cloud (VPC) configuration for the Elastic Load Balancer (ELB) and related resources."
}
