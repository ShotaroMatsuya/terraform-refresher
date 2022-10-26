# Terraform AWS RDS Database Variables
# Place holder file for AWS RDS Database

# DB Name
variable "db_name" {
  description = "AWS RDS Database Name"
  type        = string
}
# DB Instance Identifier
variable "db_instance_identifier" {
  description = "AWS RDS Database Instance Identifier"
  type        = string
}
# DB Username - Enable Sensitive flag
variable "db_username" {
  description = "AWS RDS Database Administrator Username"
  type        = string
}
# DB Password - Enable Sensitive flag
variable "db_password" {
  description = "AWS RDS Database Administrator Password"
  type        = string
  sensitive   = true
}

# DB Security Group Ids
variable "db_security_group_ids" {
  description = "AWS RDS Database Security Group Ids"
}
variable "db_subnet_ids" {
  description = "AWS RDS Tatabase Subnets Ids"
}


variable "owners" {}
variable "environment" {}

locals {
  owners      = var.owners
  environment = var.environment
  name        = "${var.owners}-${var.environment}"
  common_tags = {
    owners      = local.owners
    environment = local.environment
  }
}

