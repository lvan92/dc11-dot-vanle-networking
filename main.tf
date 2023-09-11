terraform {
  backend "s3" {
    bucket                  = "dc11-dot-van-le-networking"
    key                     = "my-terraform"
    region                  = "us-east-1"
    shared_credentials_files = "~/.aws/credentials"
  }
}

provider "aws" {
  region                  = "us-east-1"
  shared_credentials_files = "~/.aws/credentials"
}

resource "aws_vpc" "main" {
 cidr_block = "10.0.0.0/16"
 tags = {
   Name = "Networking VPC"
 }
}

resource "aws_subnet" "public_subnets" {
 count             = length(var.public_subnet_cidrs)
 vpc_id            = aws_vpc.main.id
 cidr_block        = element(var.public_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 tags = {
   Name = "Public Subnet ${count.index + 1}"
 }
}

resource "aws_subnet" "private_subnets" {
 count             = length(var.private_subnet_cidrs)
 vpc_id            = aws_vpc.main.id
 cidr_block        = element(var.private_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 tags = {
   Name = "Private Subnet ${count.index + 1}"
 }
}