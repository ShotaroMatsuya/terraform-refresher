# Input Variables
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "ap-northeast-1"
}

# AWS EC2 Instance Type
variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.micro"
}

# AWS EC2 Instance Key Pair
variable "instance_keypair" {
  description = "AWS EC2 Key Pair that need to be associated with EC2 Instance"
  type        = string
  default     = "terraform-key1"
}

# AWS DEFAULT VPC ID
variable "aws_default_vpc" {
  description = "VPC id in which AWS security groups to be created"
  type        = string
  default     = "vpc-03e8302d2aa99d578"
}