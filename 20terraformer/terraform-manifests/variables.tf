# Input Variables
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
}
# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
}
# Owners
variable "owners" {
  description = "username who created this resource"
  type        = string
}

variable "aws_account_id" {
  description = "Account ID in which AWS Resoruces to be created"
  type        = string
}
