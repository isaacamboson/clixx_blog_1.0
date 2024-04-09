
#----------------------------------------------------------------------------
#creating EIP for AWS instance - bastion in AZ-A and associating IP address
#----------------------------------------------------------------------------

#creating EIP for AWS instance
resource "aws_eip" "eip_aws_instance_bastion_az_a" {
  count = "1"
}

#associating EIP to Bastion AWS instance in AZ-A
resource "aws_eip_association" "eip_assoc_bastion_az_a" {
  count         = length(aws_instance.bastion_az_a)
  instance_id   = aws_instance.bastion_az_a[count.index].id
  allocation_id = aws_eip.eip_aws_instance_bastion_az_a[count.index].id
}

# Bastion AWS instance in AZ-A
resource "aws_instance" "bastion_az_a" {
  count                  = var.stack_controls["ec2_create"] == "Y" ? 1 : 0
  ami                    = data.aws_ami.stack_ami.id
  instance_type          = var.EC2_Components["instance_type"]
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]
  key_name                    = "bastion_kp"
  subnet_id                   = aws_subnet.pub_subnet_1.id
  associate_public_ip_address = "true"
  iam_instance_profile        = "ec2_to_s3_admin"
  user_data                   = data.template_file.bastion_s3_cp_bootstrap.rendered

  tags = {
    Name        = "Bastion_${local.AZ_A}"
    Environment = var.environment
    OwnerEmail  = var.OwnerEmail
  }
}

#----------------------------------------------------------------------------
#creating EIP for AWS instance - bastion in AZ-B and associating IP address
#----------------------------------------------------------------------------

resource "aws_eip" "eip_aws_instance_bastion_az_b" {
  count = "1"
}

#associating EIP to Bastion AWS instance in AZ-B
resource "aws_eip_association" "eip_assoc_bastion_az_b" {
  count         = length(aws_instance.bastion_az_b)
  instance_id   = aws_instance.bastion_az_b[count.index].id
  allocation_id = aws_eip.eip_aws_instance_bastion_az_b[count.index].id
}

# Bastion AWS instance in AZ-B
resource "aws_instance" "bastion_az_b" {
  count                       = var.stack_controls["ec2_create"] == "Y" ? 1 : 0
  ami                         = data.aws_ami.stack_ami.id
  instance_type               = var.EC2_Components["instance_type"]
  vpc_security_group_ids      = [aws_security_group.bastion-sg.id]
  key_name                    = "bastion_kp"
  subnet_id                   = aws_subnet.pub_subnet_2.id
  associate_public_ip_address = "true"
  iam_instance_profile        = "ec2_to_s3_admin"
  user_data                   = data.template_file.bastion_s3_cp_bootstrap.rendered

  tags = {
    Name        = "Bastion_${local.AZ_B}"
    Environment = var.environment
    OwnerEmail  = var.OwnerEmail
  }
}