variable "ecs_cluster_name" {
  type        = string
  description = "Name of the cluster."
}

variable "ecs_task_definition_import_licenses_arn" {
  type        = string
  description = "Full ARN of the import_licenses jobs Task Definition (including both family and revision)."
}

variable "ecs_task_definition_export_rds_arn" {
  type        = string
  description = "Full ARN of the export_rds jobs Task Definition (including both family and revision)."
}

variable "public_subnets" {
  description = "List of IDs of public subnets"
  type        = list(string)
}

variable "fargate_security_group_id" {
  description = "The ID of the security group"
  type        = string
}

variable "import_licenses_task_role_arn" {
  description = "ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services."
  type        = string
}

variable "import_licenses_task_execution_role_arn" {
  description = "ARN of the task execution role that the Amazon ECS container agent and the Docker daemon can assume."
  type        = string
}

variable "export_rds_task_role_arn" {
  description = "ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services."
  type        = string
}

variable "export_rds_task_execution_role_arn" {
  description = "ARN of the task execution role that the Amazon ECS container agent and the Docker daemon can assume."
  type        = string
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

