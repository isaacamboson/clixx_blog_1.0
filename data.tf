data "aws_ami" "stack_ami" {
  owners = ["self"]
  # owners      = ["767398027423"]
  name_regex  = "^stack-ami-.*"
  most_recent = true
  filter {
    name   = "name"
    values = ["stack-ami-*"]
  }
}


data "aws_route53_zone" "stack_isaac_zone" {
  name         = "stack-isaac.com." # Notice the dot!!!
  private_zone = false
}


data "aws_secretsmanager_secret_version" "creds" {
  # fill in the name you gave the secret
  secret_id = "creds"
}