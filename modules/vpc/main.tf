# Create an AWS VPC with a specified CIDR block and tags.
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name    = "vpc",
    project = "ecommerce-demo"
  }
}

# Create public subnets in the VPC with specified CIDR blocks and availability zones.
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
  
  tags = {
    Name    = "Public Subnet ${count.index + 1}",
    project = "ecommerce-demo"
  }
}

# Create private subnets in the VPC with specified CIDR blocks and availability zones.
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name    = "Private Subnet ${count.index + 1}",
    project = "ecommerce-demo"
  }
}

# Create an AWS Internet Gateway attached to the VPC.
resource "aws_internet_gateway" "internal_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name    = "Internet Gateway",
    project = "ecommerce-demo"
  }
}

# Create a public route table associated with the VPC, routing traffic through the Internet Gateway.
resource "aws_route_table" "pubic_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internal_gateway.id
  }

  tags = {
    Name    = "Public Route Table",
    project = "ecommerce-demo"
  }
}

# Create private route tables for each private subnet, routing traffic through NAT gateways.
resource "aws_route_table" "private_route_table" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }

  tags = {
    Name    = "Private Route Table ${count.index + 1}",
    project = "ecommerce-demo"
  }
}

# Create NAT gateways for each public subnet and associate Elastic IPs.
resource "aws_nat_gateway" "nat_gateway" {
  count = length(var.public_subnet_cidrs)
  subnet_id = element(aws_subnet.public_subnets[*].id, count.index)
  allocation_id = aws_eip.nat_gateway[count.index].id
  tags = {
    Name    = "Nat Gateway ${count.index + 1}",
    project = "ecommerce-demo"
  }
}

# Create Elastic IPs for NAT gateways.
resource "aws_eip" "nat_gateway" {
  count = length(var.public_subnet_cidrs)
  vpc = true
}

# Associate public route table with public subnets.
resource "aws_route_table_association" "public_subnet_asso" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.pubic_route_table.id
}

# Associate private route tables with private subnets.
resource "aws_route_table_association" "private_subnet_asso" {
  count = length(var.private_subnet_cidrs)
  subnet_id = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private_route_table[count.index].id
}

resource "aws_security_group" "load_balancer_sg" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name    = "Load Balancer Security Group",
    project = "ecommerce-demo"
  }
}

resource "aws_security_group" "ecs_task_sg" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name    = "ECS Task Security Group",
    project = "ecommerce-demo"
  }
}


resource "aws_security_group_rule" "ingress_load_balancer_sg_http" {
  from_port = 80
  protocol = "tcp"
  security_group_id = aws_security_group.load_balancer_sg.id
  to_port = 80
  cidr_blocks = [
    "0.0.0.0/0"]
  type = "ingress"
}

resource "aws_security_group_rule" "ingress_load_balancer_sg_https" {
  from_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.load_balancer_sg.id
  to_port = 443
  cidr_blocks = [
    "0.0.0.0/0"]
  type = "ingress"
}

resource "aws_security_group_rule" "ingress_ecs_task_sg_elb" {
  from_port = 80
  protocol = "tcp"
  security_group_id = aws_security_group.ecs_task_sg.id
  to_port = 80
  source_security_group_id = aws_security_group.load_balancer_sg.id
  type = "ingress"
}

resource "aws_security_group_rule" "egress_load_balancer_sg" {
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"]
  security_group_id = aws_security_group.load_balancer_sg.id
}

resource "aws_security_group_rule" "egress_ecs_task_sg" {
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_task_sg.id
}