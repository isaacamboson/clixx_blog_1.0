#creating IGW
resource "aws_internet_gateway" "custom_igw" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name = "VPC_IGW"
  }
}

#creating EIP for NAT Gateway for AZ A
resource "aws_eip" "eip_aws_nat_gtwy_prv_az_a" {
  count = 1
}

# Associating EIP with NAT Gateway for AZ A
resource "aws_nat_gateway" "nat_gateway_prv_az_a" {
  count         = length(aws_eip.eip_aws_nat_gtwy_prv_az_a)
  allocation_id = aws_eip.eip_aws_nat_gtwy_prv_az_a[count.index].id
  subnet_id     = aws_subnet.pub_subnet_1.id
  depends_on    = [aws_eip.eip_aws_nat_gtwy_prv_az_a]

  tags = {
    Name = "NAT_Gateway_${local.AZ_A}"
  }
}

#creating EIP for NAT Gateway for AZ B
resource "aws_eip" "eip_aws_nat_gtwy_prv_az_b" {
  count = 1
}

# Associating EIP with NAT Gateway for AZ B
resource "aws_nat_gateway" "nat_gateway_prv_az_b" {
  count         = length(aws_eip.eip_aws_nat_gtwy_prv_az_b)
  allocation_id = aws_eip.eip_aws_nat_gtwy_prv_az_b[count.index].id
  subnet_id     = aws_subnet.pub_subnet_2.id
  depends_on    = [aws_eip.eip_aws_nat_gtwy_prv_az_b]

  tags = {
    Name = "NAT_Gateway_${local.AZ_B}"
  }
}