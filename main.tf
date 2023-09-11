terraform {
  backend "s3" {
    bucket                  = "dc11-dot-van-le-networking"
    key                     = "my-terraform"
    region                  = "us-east-1"
    shared_credentials_file = "~/.aws/credentials"
  }
}

provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
}