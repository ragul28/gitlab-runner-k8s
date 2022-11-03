resource "aws_security_group" "eks_endpoint" {
  name   = "eks-endpoint-sg"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "eks_endpoint_443" {
  security_group_id = aws_security_group.eks_endpoint.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = concat(var.private_subnets, var.public_subnets)
}