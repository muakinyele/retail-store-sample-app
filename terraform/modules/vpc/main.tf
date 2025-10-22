resource "aws_vpc" "this" {
cidr_block = var.cidr
tags = {
Name = var.name
}
}


resource "aws_subnet" "public" {
count = length(var.availability_zones) > 0 ? length(var.availability_zones) : 2
vpc_id = aws_vpc.this.id
cidr_block = cidrsubnet(var.cidr, 8, count.index)
availability_zone = element(var.availability_zones, count.index)
map_public_ip_on_launch = true
tags = { Name = "${var.name}-public-${count.index}" }
}


resource "aws_subnet" "private" {
count = length(var.availability_zones) > 0 ? length(var.availability_zones) : 2
vpc_id = aws_vpc.this.id
cidr_block = cidrsubnet(var.cidr, 8, count.index + 10)
availability_zone = element(var.availability_zones, count.index)
tags = { Name = "${var.name}-private-${count.index}" }
}


resource "aws_internet_gateway" "igw" {
vpc_id = aws_vpc.this.id
tags = { Name = "${var.name}-igw" }
}


resource "aws_route_table" "public" {
vpc_id = aws_vpc.this.id
tags = { Name = "${var.name}-public-rt" }
}


resource "aws_route_table_association" "public_assoc" {
for_each = { for idx, sn in aws_subnet.public : idx => sn }
subnet_id = each.value.id
route_table_id = aws_route_table.public.id
}


resource "aws_route" "public_route" {
route_table_id = aws_route_table.public.id
destination_cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.igw.id
}