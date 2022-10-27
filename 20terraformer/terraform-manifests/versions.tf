# Terraform Block
terraform {
  required_version = "~> 1.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket = "terraform-fargaet-test"
    key    = "ecs/terraform.tfstate"
    # オハイオでテスト
    region = "us-east-2"

    # For State Locking
    dynamodb_table = "terraform-statelocking"
  }
}

# Provider Block
provider "aws" {
  shared_credentials_files = ["$HOME/.aws/credentials"]
  region                   = var.aws_region
  profile                  = "default"
}
# Create Random Pet Resource 
resource "random_pet" "this" {
  length = 2
}

# Create a Null Resource and provisioners
resource "null_resource" "name" {
  # Local Exec Provisioner: local-exec provisioner (Create-Time Provisioner - Triggered during Create Resource)
  provisioner "local-exec" {
    command     = "echo VPC created on `date` and VPC ID: ${module.custom_vpc.vpc_id} >> creation-time-vpc-id.txt"
    working_dir = "local-exec-output-files/"
  }
}
