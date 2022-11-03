#VPC
resource "aws_vpc" "main" {
  cidr_block           = var.main_vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/cl01" = "shared"
  }
}

# public subnet 
resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnets)

  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.az_set[count.index]
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.main.id

  tags = {
    "kubernetes.io/role/elb" = 1
  }

  # lifecycle {
  #   ignore_changes = [tags]
  # }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "route_public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta_public" {
  count = length(var.public_subnets)

  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.route_public.id
}

#Private subnets
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnets)

  cidr_block              = var.private_subnets[count.index]
  availability_zone       = var.az_set[count.index]
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.main.id

  tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  # lifecycle {
  #   ignore_changes = [tags]
  # }
}

#Route tables
resource "aws_route_table" "rt_private" {
  count = length(var.private_subnets)

  vpc_id = aws_vpc.main.id

  dynamic "route" {
    for_each = toset(var.enable_natgw == true ? ["this"] : [])
    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.nat_gw_public.id
    }
  }
}

resource "aws_route_table_association" "rta_private" {
  count = length(var.private_subnets)

  subnet_id      = aws_subnet.private_subnet.*.id[count.index]
  route_table_id = aws_route_table.rt_private.*.id[count.index]
}
