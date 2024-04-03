terraform {
  backend "s3" {
    bucket         = "stackbuckstateisaac-aut"
    key            = "terraform_blog+clixx_largeVPC.tfstate1"
    region         = "us-east-1"
    dynamodb_table = "statelock-tf"
  }
}

