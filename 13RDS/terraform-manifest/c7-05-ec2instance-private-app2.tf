# AWS EC2 Instance Terraform Module
# EC2 Instances that will be created in VPC Private Subnets for App2
module "ec2_private_app2" {
  depends_on = [ module.vpc ] # VERY VERY IMPORTANT else userdata webserver provisioning will fail
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.1.4"
  for_each = local.multiple_instances
  # insert the 10 required variables here
  name                   = "${var.environment}-app2"
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  #monitoring             = true
  vpc_security_group_ids = [module.private_sg.security_group_id]
  #subnet_id              = module.vpc.public_subnets[0]  
  # deprecated
  # subnet_ids = [
  #   module.vpc.private_subnets[0],
  #   module.vpc.private_subnets[1]
  # ]  
  subnet_id = each.value.subnet_id
  user_data = file("${path.module}/app2-install.sh")
  tags = local.common_tags
}


