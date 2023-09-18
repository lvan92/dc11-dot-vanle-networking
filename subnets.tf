resource "aws_vpc" "main" {
 cidr_block = "10.0.0.0/16"
 enable_dns_hostnames = true
 enable_dns_support   = true

 assign_generated_ipv6_cidr_block= true
 tags = {
   name = "Networking VPC"
 }
}

resource "aws_eip" "eip" {
  domain = "vpc"
}

resource "aws_internet_gateway" "public_gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    name = "Networking VPC IG"
  }
}

resource "aws_subnet" "public_subnets" {
 count             = length(var.public_subnet_cidrs)
 vpc_id            = aws_vpc.main.id
 cidr_block        = "${cidrsubnet(aws_vpc.main.cidr_block,4,count.index +1)}"
 availability_zone = element(var.azs, count.index)
 tags = {
   name = "Public Subnet ${count.index + 1}"
 }
}

resource "aws_route_table" "public_route" {
 vpc_id = aws_vpc.main.id
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.public_gateway.id
 }
 tags = {
   name = "Networking 2nd Route Table"
 }
}

resource "aws_route_table_association" "public_subnet_asso" {
 count = length(var.public_subnet_cidrs)
 subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
 route_table_id = aws_route_table.public_route.id
}

// Private subnet v6
resource "aws_egress_only_internet_gateway" "eogw" {
  vpc_id = aws_vpc.main.id

  tags = {
    name = "Networking VPC EOGW"
  }
}

resource "aws_subnet" "private_subnets" {
 count                           = length(var.private_subnet_cidrs)
 vpc_id                          = aws_vpc.main.id
 cidr_block                      = element(var.private_subnet_cidrs, count.index)
 availability_zone               = element(var.azs, count.index)

 ipv6_cidr_block                 = "${cidrsubnet(aws_vpc.main.ipv6_cidr_block,8,count.index +1)}"
 assign_ipv6_address_on_creation = true
 tags = {
   name = "Private Subnet ${count.index + 1}"
 }
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.main.id

  route {
    ipv6_cidr_block = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.eogw.id
  }

  tags = {
    name = "Networking Private Route Table"
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.public_subnet_cidrs)
  subnet_id = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private_route.id
}