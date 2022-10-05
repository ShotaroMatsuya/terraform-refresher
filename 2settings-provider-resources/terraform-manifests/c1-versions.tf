# Terraform Block
terraform {
  required_version = "~> 1.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Provider Block
provider "aws" {
  region = "ap-northeast-1"
  # profile = "default"
}

