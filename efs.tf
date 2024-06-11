#----------------------------------------------------------------
# creating the efs file system for CLIXX
#----------------------------------------------------------------
resource "aws_efs_file_system" "efs_clixx" {
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
  file_system_id  = aws_efs_file_system.efs_clixx.id
  subnet_id       = aws_subnet.private_subnets[0].id
  security_groups = [aws_security_group.app-server-sg.id]
}

# creating the efs mount target in us-east-1b
resource "aws_efs_mount_target" "efs_mount_b" {
  file_system_id  = aws_efs_file_system.efs_clixx.id
  subnet_id       = aws_subnet.private_subnets[5].id
  security_groups = [aws_security_group.app-server-sg.id]
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
  subnet_id       = aws_subnet.private_subnets[0].id
  security_groups = [aws_security_group.app-server-sg.id]
}

# creating the efs mount target in us-east-1b
resource "aws_efs_mount_target" "efs_blog_mount_b" {
  file_system_id  = aws_efs_file_system.efs_blog.id
  subnet_id       = aws_subnet.private_subnets[5].id
  security_groups = [aws_security_group.app-server-sg.id]
}


