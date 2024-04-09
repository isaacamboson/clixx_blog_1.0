#--------------------------------------------------------------
# private subnets
#--------------------------------------------------------------

#creating first private subnet - AZ A
resource "aws_subnet" "prv_subnet_1" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = var.availability_zone[0]

  tags = {
    Name = "${local.PrivatePrefix}_Subnet_1_${local.AZ_A}"
  }
}

#creating second private subnet - AZ A
resource "aws_subnet" "prv_subnet_2" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = var.availability_zone[0]

  tags = {
    Name = "${local.PrivatePrefix}_Subnet_2_${local.AZ_A}"
  }
}

#creating third private subnet - AZ A
resource "aws_subnet" "prv_subnet_3" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = var.private_subnet_cidrs[2]
  availability_zone = var.availability_zone[0]

  tags = {
    Name = "${local.PrivatePrefix}_Subnet_3_${local.AZ_A}"
  }
}

#creating fourth private subnet - AZ A
resource "aws_subnet" "prv_subnet_4" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = var.private_subnet_cidrs[3]
  availability_zone = var.availability_zone[0]

  tags = {
    Name = "${local.PrivatePrefix}_Subnet_4_${local.AZ_A}"
  }
}

#creating fifth private subnet - AZ A
resource "aws_subnet" "prv_subnet_5" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = var.private_subnet_cidrs[4]
  availability_zone = var.availability_zone[0]

  tags = {
    Name = "${local.PrivatePrefix}_Subnet_5_${local.AZ_A}"
  }
}

#creating 6th private subnet - AZ B
resource "aws_subnet" "prv_subnet_6" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = var.private_subnet_cidrs[5]
  availability_zone = var.availability_zone[1]

  tags = {
    Name = "${local.PrivatePrefix}_Subnet_6_${local.AZ_B}"
  }
}

#creating 7th private subnet - AZ B
resource "aws_subnet" "prv_subnet_7" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = var.private_subnet_cidrs[6]
  availability_zone = var.availability_zone[1]

  tags = {
    Name = "${local.PrivatePrefix}_Subnet_7_${local.AZ_B}"
  }
}

#creating 8th private subnet - AZ B
resource "aws_subnet" "prv_subnet_8" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = var.private_subnet_cidrs[7]
  availability_zone = var.availability_zone[1]

  tags = {
    Name = "${local.PrivatePrefix}_Subnet_8_${local.AZ_B}"
  }
}

#creating 9th private subnet - AZ B
resource "aws_subnet" "prv_subnet_9" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = var.private_subnet_cidrs[8]
  availability_zone = var.availability_zone[1]

  tags = {
    Name = "${local.PrivatePrefix}_Subnet_9_${local.AZ_B}"
  }
}

#creating 10th private subnet - AZ B
resource "aws_subnet" "prv_subnet_10" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = var.private_subnet_cidrs[9]
  availability_zone = var.availability_zone[1]

  tags = {
    Name = "${local.PrivatePrefix}_Subnet_10_${local.AZ_B}"
  }
}