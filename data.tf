data "aws_ami" "stack_ami" {
  owners = ["self"]
  # owners      = ["767398027423"]
  name_regex  = "^ami-stack*"
  most_recent = true
  filter {
    name   = "name"
    values = ["ami-stack-*"]
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