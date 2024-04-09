#-------------------------------------------------------------------------
#creating general security group - this allows traffic from 0.0.0.0/0
#-------------------------------------------------------------------------

resource "aws_security_group" "stack-sg" {
  vpc_id      = aws_vpc.vpc_main.id
  name        = "${local.ApplicationPrefix}-SG"
  description = "General Security Group for Clixx/Blog System"
}

#declaring "ingress" security group rules for ssh
resource "aws_security_group_rule" "ingress_ssh" {
  security_group_id = aws_security_group.stack-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

#declaring "ingress" security group rules for http
resource "aws_security_group_rule" "ingress_http" {
  security_group_id = aws_security_group.stack-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

#declaring "ingress" security group rules for ssh
resource "aws_security_group_rule" "ingress_https" {
  security_group_id = aws_security_group.stack-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

#declaring "ingress" security group rules for MySQL
resource "aws_security_group_rule" "ingress_mysql" {
  security_group_id = aws_security_group.stack-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3306
  to_port           = 3306
  cidr_blocks       = ["0.0.0.0/0"]
}

#declaring "ingress" security group rules for NFS
resource "aws_security_group_rule" "ingress_nfs" {
  security_group_id = aws_security_group.stack-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 2049
  to_port           = 2049
  cidr_blocks       = ["0.0.0.0/0"]
}

#declaring "egress" security group rules for ssh
resource "aws_security_group_rule" "egress_allow_all" {
  security_group_id = aws_security_group.stack-sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}
