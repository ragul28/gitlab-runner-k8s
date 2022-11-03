# Outputs
output "vpc_id" {
  value = aws_vpc.main.id
}

output "pvt_subnet_ids" {
  value = aws_subnet.private_subnet.*.id
}

output "pub_subnet_ids" {
  value = aws_subnet.public_subnet.*.id
}

output "eks_endpoint_sg_id" {
  value = aws_security_group.eks_endpoint.id
}