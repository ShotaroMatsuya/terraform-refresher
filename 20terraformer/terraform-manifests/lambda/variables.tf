variable "ecs_cluster" {
  type        = string
  description = "Name of the cluster."
}
variable "ecs_service" {
  type        = string
  description = "Name of the service."
}

variable "sns_topic_arn" {
  type        = string
  description = "The ARN of the SNS topic, as a more obvious property (clone of id)"
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

