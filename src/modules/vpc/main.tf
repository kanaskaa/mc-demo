resource "aws_vpc" "aws_vpc_infra" {
  lifecycle {
    ignore_changes = [id]
  }
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = "true"
  tags = {
    "Name" = "vpc-${var.product_code}-${var.env}"
    "Env" = "${var.env}"
  }
}

resource "aws_subnet" "aws_subnet_infra-public-subnet" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.aws_vpc_infra.id
  cidr_block = cidrsubnet(var.vpc_cidr, 3, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    "Name" = "Public Subnet-${element(var.availability_zones, count.index)}-${var.product_code}-${var.env}"
    "Env" = "${var.env}"
  }
}

resource "aws_subnet" "aws_subnet_infra-private-subnet" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.aws_vpc_infra.id
  cidr_block = cidrsubnet(var.vpc_cidr, 3, count.index + length(var.availability_zones))
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    "Name" = "Private Subnet-${element(var.availability_zones, count.index)}-${var.product_code}-${var.env}"
    "Env" = "${var.env}"
  }
}

resource "aws_internet_gateway" "aws_internet_gateway_infra-ig" {
  vpc_id = aws_vpc.aws_vpc_infra.id

  tags = {
    "Name" = "Internet Gateway - IDP Sandbox"
    "Env" = "${var.env}"
  }
}

resource "aws_route_table" "aws_route_table_infra-public-subnet" {
  vpc_id = aws_vpc.aws_vpc_infra.id

  route {
    cidr_block = var.route_table_cidr
    gateway_id = aws_internet_gateway.aws_internet_gateway_infra-ig.id
  }

  tags = {
    "Name" = "Public Subnet route table ${var.product_code}-${var.env}"
    "Env" = "${var.env}"

  }
}

resource "aws_route_table_association" "aws_route_table_infra-public-rt" {
  count = length(var.availability_zones)
  subnet_id = element(aws_subnet.aws_subnet_infra-public-subnet.*.id, count.index)
  route_table_id = aws_route_table.aws_route_table_infra-public-subnet.id
}


resource "aws_nat_gateway" "aws_nat_gw_infra-nat-gateway" {
  count = length(var.availability_zones)
  subnet_id = element(aws_subnet.aws_subnet_infra-public-subnet.*.id, count.index)
  allocation_id = element(aws_eip.aws_eip_infra-nat-gateway.*.id, count.index)

  tags = {
    "Name" = "Nat gateway - ${element(var.availability_zones, count.index)}-${var.product_code}-${var.env}"
    "Env" = "${var.env}"
  }
}

resource "aws_eip" "aws_eip_infra-nat-gateway" {
  count = length(var.availability_zones)
  vpc = true
}

resource "aws_route_table" "aws_route_table_infra-private-subnet" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.aws_vpc_infra.id

  route {
    cidr_block = var.route_table_cidr
    nat_gateway_id = element(aws_nat_gateway.aws_nat_gw_infra-nat-gateway.*.id, count.index)
  }

  tags = {
    "Name" = "Private Subnet route table - ${element(var.availability_zones, count.index)}-${var.product_code}-${var.env}"
    "Env" = "${var.env}"
  }
}

resource "aws_route_table_association" "aws_route_table_infra-private-rt" {
  count = length(var.availability_zones)
  subnet_id = element(aws_subnet.aws_subnet_infra-private-subnet.*.id, count.index)
  route_table_id = element(aws_route_table.aws_route_table_infra-private-subnet.*.id, count.index)
}
