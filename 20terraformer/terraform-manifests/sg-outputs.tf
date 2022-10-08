
# Security Group for RDS Aurora
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


# Fargate ECS Security Group Outputs
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


# Application Loadbalancer Security Group Outputs
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
