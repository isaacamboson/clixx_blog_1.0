#--------------------------------------------------------------
# public subnets
#--------------------------------------------------------------

#creating first public subnet
resource "aws_subnet" "pub_subnet_1" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = var.public_subnet_cidrs[0] #10.0.2.0/23
  availability_zone = var.availability_zone[0]

  tags = {
    Name = "${local.PublicPrefix}_Subnet_1_${local.AZ_A}"
  }
}

#creating second public subnet
resource "aws_subnet" "pub_subnet_2" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = var.public_subnet_cidrs[1] #10.0.4.0/23
  availability_zone = var.availability_zone[1]

  tags = {
    Name = "${local.PublicPrefix}_Subnet_2_${local.AZ_B}"
  }
}