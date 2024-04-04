
# # creating Blog App Server - AWS instance in AZ-A
# resource "aws_instance" "aws_server_blog_az_a" {
#   count                       = var.stack_controls["ec2_create_blog"] == "Y" ? 1 : 0
#   ami                         = data.aws_ami.stack_ami.id
#   instance_type               = var.EC2_Components["instance_type"]
#   vpc_security_group_ids      = [aws_security_group.app-server-sg.id, aws_security_group.bastion-sg.id]
#   user_data                   = data.template_file.bootstrap_blog.rendered
#   key_name                    = aws_key_pair.stack_key_pair.key_name
#   subnet_id                   = aws_subnet.prv_subnet_1.id
#   associate_public_ip_address = "true"

#   root_block_device {
#     volume_type           = var.EC2_Components["volume_type"]
#     volume_size           = var.EC2_Components["volume_size"]
#     delete_on_termination = var.EC2_Components["delete_on_termination"]
#     encrypted             = var.EC2_Components["encrypted"]
#   }

#   ebs_block_device {
#     device_name = "/dev/sdb"
#     volume_size = 10
#     volume_type = "gp2"
#     encrypted   = true
#     tags = {
#       Name = "EBS-${local.BlogPrefix}-Volume-1"
#     }
#   }

#   ebs_block_device {
#     device_name = "/dev/sdc"
#     volume_size = 10
#     volume_type = "gp2"
#     encrypted   = true
#     tags = {
#       Name = "EBS-${local.BlogPrefix}-Volume-2"
#     }
#   }

#   ebs_block_device {
#     device_name = "/dev/sdd"
#     volume_size = 10
#     volume_type = "gp2"
#     encrypted   = true
#     tags = {
#       Name = "EBS-${local.BlogPrefix}-Volume-3"
#     }
#   }

#   ebs_block_device {
#     device_name = "/dev/sde"
#     volume_size = 10
#     volume_type = "gp2"
#     encrypted   = true
#     tags = {
#       Name = "EBS-${local.BlogPrefix}-Volume-4"
#     }
#   }

#   ebs_block_device {
#     device_name = "/dev/sdf"
#     volume_size = 10
#     volume_type = "gp2"
#     encrypted   = true
#     tags = {
#       Name = "EBS-${local.BlogPrefix}-Volume-5"
#     }
#   }

#   tags = {
#     Name        = "${local.ServerPrefix != "" ? local.ServerPrefix : "Blog_${local.AZ_A}_"}${count.index}"
#     Environment = var.environment
#     OwnerEmail  = var.OwnerEmail
#   }
# }

# # creating Blog App Server - AWS instance in AZ-B
# resource "aws_instance" "aws_server_blog_az_b" {
#   count                       = var.stack_controls["ec2_create"] == "Y" ? 1 : 0
#   ami                         = data.aws_ami.stack_ami.id
#   instance_type               = var.EC2_Components["instance_type"]
#   vpc_security_group_ids      = [aws_security_group.app-server-sg.id, aws_security_group.bastion-sg.id]
#   user_data                   = data.template_file.bootstrap_blog.rendered
#   key_name                    = aws_key_pair.stack_key_pair.key_name
#   subnet_id                   = aws_subnet.prv_subnet_6.id
#   associate_public_ip_address = "true"

#   root_block_device {
#     volume_type           = var.EC2_Components["volume_type"]
#     volume_size           = var.EC2_Components["volume_size"]
#     delete_on_termination = var.EC2_Components["delete_on_termination"]
#     encrypted             = var.EC2_Components["encrypted"]
#   }

#   ebs_block_device {
#     device_name = "/dev/sdb"
#     volume_size = 10
#     volume_type = "gp2"
#     encrypted   = true
#     tags = {
#       Name = "EBS-${local.BlogPrefix}-Volume-1"
#     }
#   }

#   ebs_block_device {
#     device_name = "/dev/sdc"
#     volume_size = 10
#     volume_type = "gp2"
#     encrypted   = true
#     tags = {
#       Name = "EBS-${local.BlogPrefix}-Volume-2"
#     }
#   }

#   ebs_block_device {
#     device_name = "/dev/sdd"
#     volume_size = 10
#     volume_type = "gp2"
#     encrypted   = true
#     tags = {
#       Name = "EBS-${local.BlogPrefix}-Volume-3"
#     }
#   }

#   ebs_block_device {
#     device_name = "/dev/sde"
#     volume_size = 10
#     volume_type = "gp2"
#     encrypted   = true
#     tags = {
#       Name = "EBS-${local.BlogPrefix}-Volume-4"
#     }
#   }

#   ebs_block_device {
#     device_name = "/dev/sdf"
#     volume_size = 10
#     volume_type = "gp2"
#     encrypted   = true
#     tags = {
#       Name = "EBS-${local.BlogPrefix}-Volume-5"
#     }
#   }

#   tags = {
#     Name        = "${local.ServerPrefix != "" ? local.ServerPrefix : "Blog_${local.AZ_B}_"}${count.index}"
#     Environment = var.environment
#     OwnerEmail  = var.OwnerEmail
#   }
# }