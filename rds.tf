# creating subnet group name for database creation
resource "aws_db_subnet_group" "db_subnet_group_name" {
  name       = "subnet_group_name"
  subnet_ids = [aws_subnet.private_subnets[1].id, aws_subnet.private_subnets[6].id]
}

# intitiating database instance for clixx application
resource "aws_db_instance" "clixx_app_db_instance" {
  count             = var.stack_controls["rds_create_clixx"] == "Y" ? 1 : 0
  instance_class    = "db.m6gd.large"
  allocated_storage = 20
  engine            = "mysql"
  engine_version    = "8.0.28"
  identifier        = "wordpressdbclixx"
  snapshot_identifier    = "arn:aws:rds:us-east-1:767398027423:snapshot:wordpressdbclixx-snapshot"
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  parameter_group_name   = "default.mysql8.0"
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group_name.name
  skip_final_snapshot    = true
  publicly_accessible    = false
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
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  parameter_group_name   = "default.mysql8.0"
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group_name.name
  skip_final_snapshot    = true
  publicly_accessible    = false
}