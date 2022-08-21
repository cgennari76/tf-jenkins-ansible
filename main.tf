# main.tf
terraform {
  required_version = "~> 1.2.5"
}

provider "aws" {
  region = var.aws_region
}

