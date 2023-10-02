# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}

# Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# Elastic IPs for NAT gateways
resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name = "nat-eip-${count.index + 1}"
  }
}

# NAT gateways
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = {
    Name = "nat-gw-${count.index + 1}"
  }
}

# Public subnets
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  count                   = var.az_count
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-${count.index + 1}"
  }
}

# Private subnets
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  count                   = var.az_count * 2
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 2)
  availability_zone       = data.aws_availability_zones.available.names[count.index % var.az_count]
  map_public_ip_on_launch = false

  tags = {
    Name = "private-${count.index + 1}"
  }
}

# Route tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  count  = var.az_count

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat_gw.*.id, count.index)
  }
}

# Route table associations
resource "aws_route_table_association" "public" {
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private_rt.*.id, count.index)
}
