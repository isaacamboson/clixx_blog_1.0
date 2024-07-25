#-------------------------------------------------------------------------
#creating general security group - this allows traffic from 0.0.0.0/0
#-------------------------------------------------------------------------

resource "aws_security_group" "stack-sg" {
  vpc_id      = aws_vpc.vpc_main.id
  name        = "${local.ApplicationPrefix}-SG"
  description = "General Security Group for Clixx/Blog System"


  #dynamic block for allowing ingress traffic for allowing ports 80, 443, 8080, 22
  dynamic "ingress" {
    for_each = local.inbound_ports
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    description = "Allow all egress traffic"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.ApplicationPrefix}-alb-sg"
  }
}


