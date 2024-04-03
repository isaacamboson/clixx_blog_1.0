locals {
  PublicPrefix      = "Public"
  PrivatePrefix     = "Private"
  ApplicationPrefix = "clixx"
  BlogPrefix        = "blog"
  ServerPrefix      = ""
  AZ_A              = "AZ_A"
  AZ_B              = "AZ_B"
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}

#creating a VPC
resource "aws_vpc" "vpc_main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "Main_VPC"
  }
}

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

#creating IGW
resource "aws_internet_gateway" "custom_igw" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name = "VPC_IGW"
  }
}

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

# associating route tables with subnets
resource "aws_route_table_association" "rt_association_pb_sbnt_1" {
  subnet_id      = aws_subnet.pub_subnet_1.id
  route_table_id = aws_route_table.pub_custom_route_table.id
}

resource "aws_route_table_association" "rt_association_pb_sbnt_2" {
  subnet_id      = aws_subnet.pub_subnet_2.id
  route_table_id = aws_route_table.pub_custom_route_table.id
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

# creating network ACL
resource "aws_network_acl" "network_acl" {
  vpc_id     = aws_vpc.vpc_main.id
  subnet_ids = [aws_subnet.pub_subnet_1.id, aws_subnet.pub_subnet_2.id]

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${local.PublicPrefix}_NACL"
  }
}

# creating subnet group name for database creation
resource "aws_db_subnet_group" "db_subnet_group_name" {
  name       = "subnet_group_name"
  subnet_ids = [aws_subnet.prv_subnet_2.id, aws_subnet.prv_subnet_7.id]
}

# intitiating database instance for clixx application
resource "aws_db_instance" "clixx_app_db_instance" {
  count               = var.stack_controls["rds_create_clixx"] == "Y" ? 1 : 0
  instance_class      = "db.m6gd.large"
  allocated_storage   = 20
  engine              = "mysql"
  engine_version      = "8.0.28"
  identifier          = "wordpressdbclixx"
  snapshot_identifier = "arn:aws:rds:us-east-1:577701061234:snapshot:wordpressdbclixx-ecs-snapshot"
  # snapshot_identifier    = "arn:aws:rds:us-east-1:767398027423:snapshot:wordpressdbclixx-snapshot"
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  parameter_group_name   = "default.mysql8.0"
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group_name.name
  skip_final_snapshot    = true
  publicly_accessible    = false

  # tags = {
  #   Name = 
  # }
}

# intitiating database instance for blog
resource "aws_db_instance" "blog_db_instance" {
  count               = var.stack_controls["rds_create_blog"] == "Y" ? 1 : 0
  instance_class      = "db.t2.micro"
  allocated_storage   = 20
  engine              = "mysql"
  engine_version      = "8.0.35"
  identifier          = "wordpressinstance"
  snapshot_identifier = "wordpressinstance-snapshot"
  # snapshot_identifier    = "arn:aws:rds:us-east-1:767398027423:snapshot:wordpressinstance-snapshot"
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  parameter_group_name   = "default.mysql8.0"
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group_name.name
  skip_final_snapshot    = true
  publicly_accessible    = false
}

#creating private key which can be used to login to the server
resource "tls_private_key" "server_key" {
  algorithm = "RSA"
}

# declaring aws key-pair from the generated key
resource "aws_key_pair" "stack_key_pair" {
  key_name = "${local.ApplicationPrefix}_${local.BlogPrefix}-kp"
  # public_key = file(var.PATH_TO_PUBLIC_KEY)
  public_key = tls_private_key.server_key.public_key_openssh
}

# saving key to local machine
resource "local_file" "web_key" {
  content  = tls_private_key.server_key.private_key_pem
  filename = "${local.ApplicationPrefix}_and_${local.BlogPrefix}-key.pem"
}

# #declaring aws key-pair
# resource "aws_key_pair" "stack_key_pair" {
#   key_name   = "${local.ApplicationPrefix}-KP"
#   public_key = file(var.PATH_TO_PUBLIC_KEY)
# }

#--------------------------------------------------------
# Route53
#--------------------------------------------------------

# # route53 for clixx application
# resource "aws_route53_record" "clixx_route53" {
#   zone_id = data.aws_route53_zone.stack_isaac_zone.id
#   name    = "dev.clixx"
#   type    = "A"
#   # ttl     = 5

#   alias {
#     name                   = aws_lb.clixx_lb.dns_name
#     zone_id                = aws_lb.clixx_lb.zone_id
#     evaluate_target_health = true
#   }

#   depends_on = [aws_lb.clixx_lb]
# }

# # route53 for blog
# resource "aws_route53_record" "blog_route53" {
#   zone_id = data.aws_route53_zone.stack_isaac_zone.id
#   name    = "dev.blog"
#   type    = "A"
#   # ttl     = 5

#   alias {
#     name                   = aws_lb.blog_lb.dns_name
#     zone_id                = aws_lb.blog_lb.zone_id
#     evaluate_target_health = true
#   }

#   depends_on = [aws_lb.blog_lb]
# }


