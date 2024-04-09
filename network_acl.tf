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