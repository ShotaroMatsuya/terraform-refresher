# Define Local Values in Terraform
locals {
  owners      = var.business_divsion
  environment = var.environment
  name        = "${var.business_divsion}-${var.environment}"
  common_tags = {
    owners      = local.owners
    environment = local.environment
  }
  multiple_instances = {
    0 = {
      num_suffix    = 1
      instance_type = "c5.large"
      subnet_id     = element(module.vpc.private_subnets, 0)
      # subnet_id = module.vpc.private_subnets[0]
    }
    1 = {
      num_suffix    = 2
      instance_type = "c5.large"
      subnet_id     = element(module.vpc.private_subnets, 1)
      # subnet_id = module.vpc.private_subnets[1]
    }
  }
}