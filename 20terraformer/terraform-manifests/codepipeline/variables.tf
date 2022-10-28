variable "ecs_service_name" {
  description = "Name of the service for ."
}

variable "ecs_cluster_name" {
  description = "Name of the ECS clsuter for "
}

variable "sns_topic_arn" {
  description = "The ARN of the SNS topic, as a more obvious property (clone of id)"
}

variable "full_repositoy_id" {
  description = "the git repository full id"
}

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


