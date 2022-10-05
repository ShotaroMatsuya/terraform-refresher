# AWS EC2 Instance Terraform Outputs
# Public EC2 Instances - Bastion Host
output "ec2_bastion_public_instance_ids" {
  description = "List of IDs of instances"
  value       = module.ec2_public.id
}
output "ec2_bastion_public_ip" {
  description = "List of Public ip address assigned to the instances"
  value       = module.ec2_public.public_ip
}
# App1 - Private EC2 Instances
## ec2_private_instance_ids
output "app1_ec2_private_instance_ids" {
  description = "List of IDs of instances"
  # value       = module.ec2_private.id
  # for_eachで回したので変更
  value = toset([
    for myec2vm in module.ec2_private_app1 : myec2vm.id
  ])

}
## ec2_private_ip
output "app1_ec2_private_ip" {
  description = "List of private ip address assigned to the instances"
  # value       = module.ec2_private.private_ip
  # for_eachで回したので変更
  value = toset([
    for myec2vm in module.ec2_private_app1 : myec2vm.private_ip
  ])
}
# App2 - Private EC2 Instances
## ec2_private_instance_ids
output "app2_ec2_private_instance_ids" {
  description = "List of IDs of instances"
  # value       = module.ec2_private.id
  # for_eachで回したので変更
  value = toset([
    for myec2vm in module.ec2_private_app2 : myec2vm.id
  ])
}
## ec2_private_ip
output "app2_ec2_private_ip" {
  description = "List of private ip address assigned to the instances"
  # value       = module.ec2_private.private_ip
  # for_eachで回したので変更
  value = toset([
    for myec2vm in module.ec2_private_app2 : myec2vm.private_ip
  ])
}