output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public1.id
}

output "private_subnet_id" {
  value = aws_subnet.private1.id
}

output "private_route_table_id" {
  value = aws_route_table.private1.id
}
