locals {
  PublicPrefix      = "Public"
  PrivatePrefix     = "Private"
  ApplicationPrefix = "clixx"
  BlogPrefix        = "blog"
  ServerPrefix      = ""
  AZ_A              = "AZ_A"
  AZ_B              = "AZ_B"

  inbound_ports     = [80, 443, 8080, 22, 3306, 2049]

  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}

# #creating private key which can be used to login to the server
# resource "tls_private_key" "server_key" {
#   algorithm = "RSA"
# }

# # declaring aws key-pair from the generated key
# resource "aws_key_pair" "stack_key_pair" {
#   key_name = "${local.ApplicationPrefix}_${local.BlogPrefix}-kp"
#   # public_key = file(var.PATH_TO_PUBLIC_KEY)
#   public_key = tls_private_key.server_key.public_key_openssh
# }

# # saving key to local machine
# resource "local_file" "web_key" {
#   content  = tls_private_key.server_key.private_key_pem
#   filename = "${local.ApplicationPrefix}_and_${local.BlogPrefix}-key.pem"
# }

# #declaring aws key-pair
# resource "aws_key_pair" "stack_key_pair" {
#   key_name   = "${local.ApplicationPrefix}-KP"
#   public_key = file(var.PATH_TO_PUBLIC_KEY)
# }

