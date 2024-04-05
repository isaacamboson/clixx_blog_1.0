#----------------------------------------------------------------
# creating the efs file system for CLIXX
#----------------------------------------------------------------
resource "aws_efs_file_system" "efs_1" {
  creation_token   = "${local.ApplicationPrefix}-EFS"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"
  tags = {
    Name = "${local.ApplicationPrefix}-EFS"
  }
}

# creating the efs mount target in us-east-1a
resource "aws_efs_mount_target" "efs_mount_a" {
  file_system_id  = aws_efs_file_system.efs_1.id
  subnet_id       = aws_subnet.prv_subnet_1.id
  security_groups = [aws_security_group.stack-sg.id]
}

# creating the efs mount target in us-east-1b
resource "aws_efs_mount_target" "efs_mount_b" {
  file_system_id  = aws_efs_file_system.efs_1.id
  subnet_id       = aws_subnet.prv_subnet_6.id
  security_groups = [aws_security_group.stack-sg.id]
}

#----------------------------------------------------------------
# creating the efs file system for BLOG
#----------------------------------------------------------------
resource "aws_efs_file_system" "efs_blog" {
  creation_token   = "${local.BlogPrefix}-EFS"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"
  tags = {
    Name = "${local.BlogPrefix}-EFS"
  }
}

# creating the efs mount target in us-east-1a
resource "aws_efs_mount_target" "efs_blog_mount_a" {
  file_system_id  = aws_efs_file_system.efs_blog.id
  subnet_id       = aws_subnet.pub_subnet_1.id
  security_groups = [aws_security_group.stack-sg.id]
}

# creating the efs mount target in us-east-1b
resource "aws_efs_mount_target" "efs_blog_mount_b" {
  file_system_id  = aws_efs_file_system.efs_blog.id
  subnet_id       = aws_subnet.pub_subnet_2.id
  security_groups = [aws_security_group.stack-sg.id]
}

