variable "buildspec_path" {
  description = "The build spec declaration to use for this build project's related builds. This must be set when type is NO_SOURCE. It can either be a path to a file residing in the repository to be built or a local file path leveraging the file() built-in."
}


variable "owners" {}
variable "environment" {}
variable "aws_region" {}
variable "aws_account_id" {}

locals {
  owners      = var.owners
  environment = var.environment
  name        = "${var.owners}-${var.environment}"
  common_tags = {
    owners      = local.owners
    environment = local.environment
  }
}
