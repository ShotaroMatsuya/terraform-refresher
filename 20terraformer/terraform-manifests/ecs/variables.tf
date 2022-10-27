##########################
# ECS Input Variables    #
# ECS Cluster Name       #
##########################
variable "cluster_settings" {
  description = "Configuration block(s) with cluster settings. For example, this can be used to enable CloudWatch Container Insights for a cluster"
  type        = map(string)
}

variable "proxy_port" {
  description = ""
  type        = string
}

variable "proxy_container_name" {
  description = ""
  type        = string
}

variable "fargate_cpu" {
  type        = number
  description = "Fargate Cpu allocation"
}

variable "fargate_memory" {
  type        = number
  description = "Fargate Memory allocation"
}

variable "nginx_image_uri" {
  type = string
}

variable "php_image_uri" {
  type = string
}

variable "fluentbit_image_uri" {
  type = string
}

variable "nginx_container_port" {
  type = number
}

variable "php_container_port" {
  type = number
}

variable "firelens_log_group" {
  type = string
}

variable "ecs_volume_name" {
  type = string
}

variable "ecs_volume_path" {
  type = string
}

# alb target group arns
variable "alb_target_group_arns" {
  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group."
}
# security group
variable "fargate_security_group_id" {
  description = "The ID of the security group"
}
# subnets
variable "public_subnets_ids" {
  description = "List of IDs of public subnets"
}

########################################
# Define Local Values in Terraform     #
########################################

variable "owners" {}
variable "environment" {}
variable "aws_region" {}

locals {
  owners      = var.owners
  environment = var.environment
  name        = "${var.owners}-${var.environment}"
  common_tags = {
    owners      = local.owners
    environment = local.environment
  }
}

