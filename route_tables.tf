#creating a custom route table for the public subnet
resource "aws_route_table" "pub_custom_route_table" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom_igw.id
  }

  tags = {
    Name = "${local.PublicPrefix}_Route_Table"
  }
}

# associating above custom route table with public subnets
resource "aws_route_table_association" "rt_association_pb_sbnt_1" {
  subnet_id      = aws_subnet.pub_subnet_1.id
  route_table_id = aws_route_table.pub_custom_route_table.id
}

resource "aws_route_table_association" "rt_association_pb_sbnt_2" {
  subnet_id      = aws_subnet.pub_subnet_2.id
  route_table_id = aws_route_table.pub_custom_route_table.id
}

#creating a custom route table for the private subnet - AZ A
resource "aws_route_table" "prv_custom_route_table_az_a" {
  count  = 1
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway_prv_az_a[count.index].id
  }

  tags = {
    Name = "${local.PrivatePrefix}_Route_Table_${local.AZ_A}"
  }
}

#creating a custom route table for the private subnet - AZ B
resource "aws_route_table" "prv_custom_route_table_az_b" {
  count  = 1
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway_prv_az_b[count.index].id
  }

  tags = {
    Name = "${local.PrivatePrefix}_Route_Table_${local.AZ_B}"
  }
}

# associating route tables with subnets
resource "aws_route_table_association" "rt_association_prv_sbnt_1" {
  count          = 1
  subnet_id      = aws_subnet.prv_subnet_1.id
  route_table_id = aws_route_table.prv_custom_route_table_az_a[count.index].id
}

# resource "aws_route_table_association" "rt_association_prv_sbnt_2" {
#   count          = 1
#   subnet_id      = aws_subnet.prv_subnet_2.id
#   route_table_id = aws_route_table.prv_custom_route_table_az_a[count.index].id
# }

resource "aws_route_table_association" "rt_association_prv_sbnt_3" {
  count          = 1
  subnet_id      = aws_subnet.prv_subnet_3.id
  route_table_id = aws_route_table.prv_custom_route_table_az_a[count.index].id
}

resource "aws_route_table_association" "rt_association_prv_sbnt_4" {
  count          = 1
  subnet_id      = aws_subnet.prv_subnet_4.id
  route_table_id = aws_route_table.prv_custom_route_table_az_a[count.index].id
}

resource "aws_route_table_association" "rt_association_prv_sbnt_5" {
  count          = 1
  subnet_id      = aws_subnet.prv_subnet_5.id
  route_table_id = aws_route_table.prv_custom_route_table_az_a[count.index].id
}

resource "aws_route_table_association" "rt_association_prv_sbnt_6" {
  count          = 1
  subnet_id      = aws_subnet.prv_subnet_6.id
  route_table_id = aws_route_table.prv_custom_route_table_az_b[count.index].id
}

# resource "aws_route_table_association" "rt_association_prv_sbnt_7" {
#   count          = 1
#   subnet_id      = aws_subnet.prv_subnet_7.id
#   route_table_id = aws_route_table.prv_custom_route_table_az_b[count.index].id
# }

resource "aws_route_table_association" "rt_association_prv_sbnt_8" {
  count          = 1
  subnet_id      = aws_subnet.prv_subnet_8.id
  route_table_id = aws_route_table.prv_custom_route_table_az_b[count.index].id
}

resource "aws_route_table_association" "rt_association_prv_sbnt_9" {
  count          = 1
  subnet_id      = aws_subnet.prv_subnet_9.id
  route_table_id = aws_route_table.prv_custom_route_table_az_b[count.index].id
}

resource "aws_route_table_association" "rt_association_prv_sbnt_10" {
  count          = 1
  subnet_id      = aws_subnet.prv_subnet_10.id
  route_table_id = aws_route_table.prv_custom_route_table_az_b[count.index].id
}