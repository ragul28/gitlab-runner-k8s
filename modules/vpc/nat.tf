# Nat gateway placed under public subnet to route to traffic to igw
resource "aws_eip" "nat_gw_eip" {
  count = var.enable_natgw == true ? 1 : 0
  vpc   = true
}

resource "aws_nat_gateway" "nat_gw_public" {
  count = var.enable_natgw == true ? 1 : 0

  allocation_id = var.enable_natgw == true ? aws_eip.nat_gw_eip.0.id : null
  subnet_id     = var.enable_natgw == true ? aws_subnet.public_subnet.0.id : null
}