#----------------------------------------------------------------------
#creating security group for rds instance
#----------------------------------------------------------------------
resource "aws_security_group" "rds-sg" {
  vpc_id      = aws_vpc.vpc_main.id
  name        = "${local.ApplicationPrefix}_rds-sg"
  description = "Security Group for rds instance in private subnet"

  ingress {
    description     = "Allow ingress traffic for mysql"
    protocol        = "tcp"
    from_port       = 3306
    to_port         = 3306
    security_groups = [aws_security_group.app-server-sg.id, aws_security_group.bastion-sg.id]
  }

  egress {
    description = "Allow all egress traffic"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}