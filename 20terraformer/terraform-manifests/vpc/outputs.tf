###########################
# VPC Output Values       #
###########################
# VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# VPC CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

# VPC Private Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

# VPC Public Subnets
output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

# VPC NAT gateway Public IP
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

# VPC AZs
output "azs" {
  description = "A list of availability zones spefified as argument to this module"
  value       = module.vpc.azs
}

output "database_subnet_group_name" {
  description = "Name of database subnet group"
  value       = module.vpc.database_subnet_group_name
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc.database_subnets
}

##########################################################
# Terraform AWS Application Load Balancer (ALB) Outputs  #
##########################################################
output "this_lb_id" {
  description = "The ID and ARN of the load balancer we created."
  value       = module.alb.lb_id
}

output "this_lb_arn" {
  description = "The ID and ARN of the load balancer we created."
  value       = module.alb.lb_arn
}

output "this_lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.alb.lb_dns_name
}

output "this_lb_arn_suffix" {
  description = "ARN suffix of our load balancer - can be used with CloudWatch."
  value       = module.alb.lb_arn_suffix
}

output "this_lb_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records."
  value       = module.alb.lb_zone_id
}

output "http_tcp_listener_arns" {
  description = "The ARN of the TCP and HTTP load balancer listeners created."
  value       = module.alb.http_tcp_listener_arns
}

output "http_tcp_listener_ids" {
  description = "The IDs of the TCP and HTTP load balancer listeners created."
  value       = module.alb.http_tcp_listener_ids
}

output "https_listener_arns" {
  description = "The ARNs of the HTTPS load balancer listeners created."
  value       = module.alb.https_listener_arns
}

output "https_listener_ids" {
  description = "The IDs of the load balancer listeners created."
  value       = module.alb.https_listener_ids
}

output "target_group_arns" {
  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group."
  value       = module.alb.target_group_arns
}

output "target_group_arn_suffixes" {
  description = "ARN suffixes of our target groups - can be used with CloudWatch."
  value       = module.alb.target_group_arn_suffixes
}

output "target_group_names" {
  description = "Name of the target group. Useful for passing to your CodeDeploy Deployment Group."
  value       = module.alb.target_group_names
}

output "target_group_attachments" {
  description = "ARNs of the target group attachment IDs."
  value       = module.alb.target_group_attachments
}

#######################################
# Security Group for RDS Aurora       #
#######################################
output "rds_aurora_sg_group_id" {
  description = "The ID of the security group"
  value       = module.rds_aurora_sg.security_group_id
}
output "rds_aurora_sg_group_vpc_id" {
  description = "The VPC ID"
  value       = module.rds_aurora_sg.security_group_vpc_id
}
output "rds_aurora_sg_group_name" {
  description = "The name of the security group"
  value       = module.rds_aurora_sg.security_group_name
}

#########################################
# Fargate ECS Security Group Outputs    #
#########################################
output "fargate_sg_group_id" {
  description = "The ID of the security group"
  value       = module.fargate_sg.security_group_id
}
output "fargate_sg_group_vpc_id" {
  description = "The VPC ID"
  value       = module.fargate_sg.security_group_vpc_id
}
output "fargate_sg_group_name" {
  description = "The name of the security group"
  value       = module.fargate_sg.security_group_name
}

#######################################################
# Application Loadbalancer Security Group Outputs     #
#######################################################
output "loadbalancer_sg_group_id" {
  description = "The ID of the security group"
  value       = module.loadbalancer_sg.security_group_id
}
output "loadbalancer_sg_group_vpc_id" {
  description = "The VPC ID"
  value       = module.loadbalancer_sg.security_group_vpc_id
}
output "loadbalancer_sg_group_name" {
  description = "The name of the security group"
  value       = module.loadbalancer_sg.security_group_name
}
##################################
# Output ACM Certificate ARN     #
##################################
output "this_acm_certificate_arn" {
  description = "The ARN of the certificate"
  value       = module.acm.acm_certificate_arn
}
################################
# Output MyDomain Zone ID      #
################################
output "mydomain_zoneid" {
  description = "The Hosted Zone id of the desired Hosted Zone"
  value       = data.aws_route53_zone.mydomain.zone_id
}
##############################
# Output MyDomain name       #
##############################
output "mydomain_name" {
  description = " The Hosted Zone name of the desired Hosted Zone."
  value       = data.aws_route53_zone.mydomain.name
}
