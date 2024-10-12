

resource "aws_vpc" "eks_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "eks-private-vpc"
  }
}

resource "aws_subnet" "eks_private_subnet" {
  count           = length(var.private_subnet_cidrs)
  vpc_id          = aws_vpc.eks_vpc.id
  cidr_block      = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "eks-private-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "eks_public_subnet" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "eks-public-subnet"
  }
}

resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name = "eks-internet-gateway"
  }
}

resource "aws_route_table" "eks_public_route_table" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name = "eks-public-route-table"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.eks_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.eks_igw.id
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.eks_public_subnet.id
  route_table_id = aws_route_table.eks_public_route_table.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "eks_nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.eks_public_subnet.id
  tags = {
    Name = "eks-nat-gateway"
  }
}

resource "aws_route_table" "eks_private_route_table" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name = "eks-private-route-table"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.eks_private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.eks_nat_gateway.id
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(aws_subnet.eks_private_subnet)
  subnet_id      = element(aws_subnet.eks_private_subnet.*.id, count.index)
  route_table_id = aws_route_table.eks_private_route_table.id
}

data "aws_availability_zones" "available" {}

output "vpc_id" {
  value = aws_vpc.eks_vpc.id
}


output "private_subnet_ids" {
  value = aws_subnet.eks_private_subnet[*].id
}