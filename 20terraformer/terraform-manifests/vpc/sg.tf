# VPC Security Group Terraform Module
# Security Group for RDS Aurora
module "rds_aurora_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.13.0"

  name        = "rds-aurora-sg"
  description = "Security group for RDS Aurora"
  vpc_id      = module.vpc.vpc_id
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags         = local.common_tags
  # Open for security group id (rule or from_port+to_port+protocol+description)
  ingress_with_source_security_group_id = [
    {
      from_port                = 5432
      to_port                  = 5432
      protocol                 = 6
      description              = "Ingress from msqb-cms"
      source_security_group_id = module.fargate_sg.security_group_id
    },
  ]
}

# AWS EC2 Security Group Terraform Module
# Security Group for ECS fargate container
module "fargate_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.13.0"

  name        = "fargate-sg"
  description = "Security group with Ingress from other containers in the same security group"
  vpc_id      = module.vpc.vpc_id

  egress_rules = ["all-all"]
  tags         = local.common_tags
  # Open for self (rule or from_port+to_port+protocol+description)
  ingress_with_self = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "Ingress from other containers in the same security group"
      self        = true
    }
  ]
  # Open for security group id (rule or from_port+to_port+protocol+description)
  ingress_with_source_security_group_id = [
    {
      from_port                = 0
      to_port                  = 0
      protocol                 = -1
      description              = "Ingress from the public ALB"
      source_security_group_id = module.loadbalancer_sg.security_group_id
    },
  ]
}

# Security Group for Public Load Balancer
module "loadbalancer_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.13.0"

  name        = "loadbalancer-sg"
  description = "Security Group with HTTP open for entire Internet (IPv4 CIDR), egress ports are all world open"
  vpc_id      = module.vpc.vpc_id
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags         = local.common_tags

  # Open to CIDRs blocks (rule or from_port+to_port+protocol+description)
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = 6
      description = "matsuya from home"
      cidr_blocks = "160.237.141.236/32"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = 6
      description = "matsuya from home"
      cidr_blocks = "160.237.141.236/32"
    },
  ]
}
