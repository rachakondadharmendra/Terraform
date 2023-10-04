output "vpc" {
  value = aws_vpc.vpc
}

output "public_subnets" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnets" {
  value = aws_subnet.private_subnets[*].id
}

output "internet_gateway" {
  value = aws_internet_gateway.internal_gateway.id
}

output "public_route_table" {
  value = aws_route_table.pubic_route_table.id
}

output "private_route_tables" {
  value = aws_route_table.private_route_table[*].id
}

output "nat_gateways" {
  value = aws_nat_gateway.nat_gateway[*].id
}

output "elastic_ips" {
  value = aws_eip.nat_gateway[*].id
}

output "load_balancer_security_group" {
  value = aws_security_group.load_balancer_sg.id
}

output "ecs_task_sg" {
  value = aws_security_group.ecs_task_sg.id
}
