#----------------------------------------------------------------------------
#creating EIP for AWS instance - bastion in AZ-A and associating IP address
#----------------------------------------------------------------------------

#creating two EIPs for AWS Bastion instances
resource "aws_eip" "eip_aws_instance_bastion" {
  count = length(var.availability_zone)
}

#associating EIPs to Bastion AWS instances in AZ-A and AZ-B
resource "aws_eip_association" "eip_assoc_bastion" {
  count         = length(var.public_subnet_cidrs)
  instance_id   = element(aws_instance.bastion.*.id, count.index)
  allocation_id = element(aws_eip.eip_aws_instance_bastion.*.id, count.index)
}

# Bastion AWS instance in AZ-A
resource "aws_instance" "bastion" {
  count                       = var.stack_controls["ec2_create"] == "Y" ? 2 : 0
  ami                         = data.aws_ami.stack_ami.id
  instance_type               = var.EC2_Components["instance_type"]
  vpc_security_group_ids      = [aws_security_group.bastion-sg.id]
  key_name                    = "bastion_kp"
  subnet_id                   = element(aws_subnet.pub_subnets.*.id, count.index)
  associate_public_ip_address = "true"
  iam_instance_profile        = "ec2_to_s3_admin"
  user_data                   = data.template_file.bastion_s3_cp_bootstrap.rendered

  tags = {
    Name        = "Bastion_${count.index}"
    Environment = var.environment
    OwnerEmail  = var.OwnerEmail
  }
}
