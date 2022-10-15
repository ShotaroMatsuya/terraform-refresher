# Input Variables
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "us-east-2"
}
# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "test"
}
# Owners
variable "owners" {
  description = "username who created this resource"
  type        = string
  default     = "matsuya"
}

variable "aws_account_id" {
  description = "Account ID in which AWS Resoruces to be created"
  type        = string
  default     = "528163014577"
}
