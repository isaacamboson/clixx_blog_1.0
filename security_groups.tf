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

#-------------------------------------------------------------------------
#creating security group for bastion - this allows traffic from 0.0.0.0/0
#-------------------------------------------------------------------------

resource "aws_security_group" "bastion-sg" {
  vpc_id      = aws_vpc.vpc_main.id
  name        = "bastion-sg"
  description = "Security Group for bastion - this allows traffic from 0.0.0.0/0"
}

#declaring "ingress" security group rules for ssh
resource "aws_security_group_rule" "ingress_ssh_bastion_sg" {
  security_group_id = aws_security_group.bastion-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

#declaring "ingress" security group rules for http
resource "aws_security_group_rule" "ingress_http_bastion_sg" {
  security_group_id = aws_security_group.bastion-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

#declaring "ingress" security group rules for ssh
resource "aws_security_group_rule" "ingress_https_bastion_sg" {
  security_group_id = aws_security_group.bastion-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

#declaring "ingress" security group rules for MySQL
resource "aws_security_group_rule" "ingress_mysql_bastion_sg" {
  security_group_id = aws_security_group.bastion-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3306
  to_port           = 3306
  cidr_blocks       = ["0.0.0.0/0"]
}

#declaring "ingress" security group rules for ICMP
resource "aws_security_group_rule" "ingress_icmp_bastion_sg" {
  security_group_id = aws_security_group.bastion-sg.id
  type              = "ingress"
  protocol          = "icmp"
  from_port         = -1
  to_port           = -1
  cidr_blocks       = ["0.0.0.0/0"]
}

#declaring "egress" security group rules for ssh
resource "aws_security_group_rule" "egress_allow_all_bastion_sg" {
  security_group_id = aws_security_group.bastion-sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

#----------------------------------------------------------------------
#creating security group for app server
#----------------------------------------------------------------------
resource "aws_security_group" "app-server-sg" {
  vpc_id      = aws_vpc.vpc_main.id
  name        = "app-server-sg"
  description = "Security Group for Application Server in private subnets"
}

#declaring "ingress" security group rules for ssh
resource "aws_security_group_rule" "ingress_ssh_app-server_sg" {
  security_group_id        = aws_security_group.app-server-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = aws_security_group.bastion-sg.id
}

#declaring "ingress" security group rules for http
resource "aws_security_group_rule" "ingress_http_app-server_sg" {
  security_group_id        = aws_security_group.app-server-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = aws_security_group.bastion-sg.id
}

#declaring "ingress" security group rules for ssh
resource "aws_security_group_rule" "ingress_https_app-server_sg" {
  security_group_id        = aws_security_group.app-server-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  source_security_group_id = aws_security_group.bastion-sg.id
}

#declaring "ingress" security group rules for MySQL
resource "aws_security_group_rule" "ingress_mysql_app-server_sg" {
  security_group_id        = aws_security_group.app-server-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.bastion-sg.id
}

#declaring "ingress" security group rules for ICMP
resource "aws_security_group_rule" "ingress_icmp_app-server_sg" {
  security_group_id        = aws_security_group.app-server-sg.id
  type                     = "ingress"
  protocol                 = "icmp"
  from_port                = -1
  to_port                  = -1
  source_security_group_id = aws_security_group.bastion-sg.id
}

#declaring "egress" security group rules for ssh
resource "aws_security_group_rule" "egress_allow_all_app-server_sg" {
  security_group_id        = aws_security_group.app-server-sg.id
  type                     = "egress"
  protocol                 = "-1"
  from_port                = 0
  to_port                  = 0
  source_security_group_id = aws_security_group.bastion-sg.id
}

#----------------------------------------------------------------------
#creating security group for rds instance
#----------------------------------------------------------------------
resource "aws_security_group" "rds-sg" {
  vpc_id      = aws_vpc.vpc_main.id
  name        = "rds-sg"
  description = "Security Group for rds instance in private subnet"
}

#declaring "ingress" security group rules for ssh
resource "aws_security_group_rule" "ingress_ssh_rds_sg" {
  security_group_id        = aws_security_group.rds-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = aws_security_group.app-server-sg.id
}

#declaring "ingress" security group rules for ssh
resource "aws_security_group_rule" "ingress_ssh_rds_fb_sg" {
  security_group_id        = aws_security_group.rds-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = aws_security_group.bastion-sg.id
}

#declaring "ingress" security group rules for http
resource "aws_security_group_rule" "ingress_http_rds_sg" {
  security_group_id        = aws_security_group.rds-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = aws_security_group.app-server-sg.id
}

#declaring "ingress" security group rules for http
resource "aws_security_group_rule" "ingress_http_rds_fb_sg" {
  security_group_id        = aws_security_group.rds-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = aws_security_group.bastion-sg.id
}

#declaring "ingress" security group rules for ssh
resource "aws_security_group_rule" "ingress_https_rds_sg" {
  security_group_id        = aws_security_group.rds-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  source_security_group_id = aws_security_group.app-server-sg.id
}

#declaring "ingress" security group rules for ssh
resource "aws_security_group_rule" "ingress_https_rds_fb_sg" {
  security_group_id        = aws_security_group.rds-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  source_security_group_id = aws_security_group.bastion-sg.id
}

#declaring "ingress" security group rules for MySQL
resource "aws_security_group_rule" "ingress_mysql_rds_sg" {
  security_group_id        = aws_security_group.rds-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.app-server-sg.id
}

#declaring "ingress" security group rules for MySQL
resource "aws_security_group_rule" "ingress_mysql_rds_fb_sg" {
  security_group_id        = aws_security_group.rds-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.bastion-sg.id
}

#declaring "ingress" security group rules for ICMP
resource "aws_security_group_rule" "ingress_icmp_rds_sg" {
  security_group_id        = aws_security_group.rds-sg.id
  type                     = "ingress"
  protocol                 = "icmp"
  from_port                = -1
  to_port                  = -1
  source_security_group_id = aws_security_group.app-server-sg.id
}

#declaring "ingress" security group rules for ICMP
resource "aws_security_group_rule" "ingress_icmp_rds_fb_sg" {
  security_group_id        = aws_security_group.rds-sg.id
  type                     = "ingress"
  protocol                 = "icmp"
  from_port                = -1
  to_port                  = -1
  source_security_group_id = aws_security_group.bastion-sg.id
}

#declaring "egress" security group rules for ssh
resource "aws_security_group_rule" "egress_allow_all_rds_sg" {
  security_group_id        = aws_security_group.rds-sg.id
  type                     = "egress"
  protocol                 = "-1"
  from_port                = 0
  to_port                  = 0
  source_security_group_id = aws_security_group.app-server-sg.id
}

#declaring "egress" security group rules for ssh
resource "aws_security_group_rule" "egress_allow_all_rds_fb_sg" {
  security_group_id        = aws_security_group.rds-sg.id
  type                     = "egress"
  protocol                 = "-1"
  from_port                = 0
  to_port                  = 0
  source_security_group_id = aws_security_group.bastion-sg.id
}