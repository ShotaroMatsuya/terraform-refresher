# EC2 Instances that will be created in VPC Private Subnets
module "ec2_private" {
  depends_on = [
    module.vpc
  ]
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.1.4"

  for_each = local.multiple_instances

  name          = "${var.environment}-vm-${each.value.num_suffix}"
  ami           = data.aws_ami.amzlinux2.id
  instance_type = each.value.instance_type
  user_data     = file("${path.module}/app1-install.sh")
  key_name      = var.instance_keypair

  vpc_security_group_ids = [module.private_sg.security_group_id]
  subnet_id              = each.value.subnet_id

  tags = local.common_tags
}