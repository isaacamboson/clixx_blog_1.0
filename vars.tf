variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  default = "us-east-1"
}

variable "availability_zone" {
  default = [
    "us-east-1a",
    "us-east-1b"
  ]
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type = list(string)
  default = [
    "10.0.2.0/23", # 510 hosts   - bastion, load balancer
    "10.0.4.0/23"  # 510 hosts   - bastion, load balancer
  ]
}

variable "private_subnet_cidrs" {
  type = list(string)
  default = [
    "10.0.0.0/24",  # 254 hosts   - Application Server
    "10.0.8.0/22",  # 1022 hosts  - RDS
    "10.0.16.0/24", # 254 hosts   - Oracle DB
    "10.0.18.0/26", # 62 hosts    - deployment of Java app db
    "10.0.20.0/26", # 62 hosts    - deployment of Java app db
    "10.0.1.0/24",  # 254 hosts   - Application Server
    "10.0.12.0/22", # 1022 hosts  - RDS
    "10.0.17.0/24", # 254 hosts   - Oracle DB
    "10.0.19.0/26", # 62 hosts    - deployment of Java app db
    "10.0.21.0/26"  # 62 hosts    - deployment of Java appn db
  ]
}

variable "environment" {
  default = "dev"
}

# variable "PATH_TO_PRIVATE_KEY" {
#   default = "my_key"
# }

# variable "PATH_TO_PUBLIC_KEY" {
#   default = "my_key.pub"
# }

variable "OwnerEmail" {
  default = "isaacamboson@gmail.com"
}

#controls / conditionals
variable "stack_controls" {
  type = map(string)
  default = {
    ec2_create       = "Y"
    ec2_create_clixx = "Y"
    ec2_create_blog  = "Y"
    rds_create_clixx = "Y"
    rds_create_blog  = "Y"
  }
}

#components for EC2 instances
variable "EC2_Components" {
  type = map(string)
  default = {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = true
    encrypted             = "true"
    instance_type         = "t2.micro"
  }
}

# rds / database variables for clixx app
# variable "rds_ept" {}
# variable "rds_usr" {}
# variable "rds_pwd" {}
# variable "rds_db" {}
# variable "git_repo1" {}

# rds / database variables for blog
# variable "rds_ept_blog" {}
# variable "rds_usr_blog" {}
# variable "rds_pwd_blog" {}
# variable "rds_db_blog" {}
# variable "git_repo_blog" {}