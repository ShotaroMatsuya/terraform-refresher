module "custom_vpc" {
  source                                 = "./vpc"
  vpc_name                               = "myvpc"
  vpc_cidr_block                         = "10.0.0.0/16"
  vpc_availability_zones                 = ["us-east-2a", "us-east-2b", "us-east-2c"]
  vpc_public_subnets                     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  vpc_private_subnets                    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  vpc_database_subnets                   = ["10.0.151.0/24", "10.0.152.0/24", "10.0.153.0/24"]
  vpc_create_database_subnet_group       = true
  vpc_create_database_subnet_route_table = true
  vpc_enable_nat_gateway                 = true
  vpc_single_nat_gateway                 = true
  acm_arn                                = "arn:aws:acm:ap-northeast-1:528163014577:certificate/47405301-9f43-4d12-b5b8-368b206f292b"

  owners      = "matsuya"
  environment = "test"
}
/*
module "custom_rds" {
  source                 = "./rds"
  db_instance_identifier = "webappdb"
  db_security_group_ids  = module.custom_vpc.rds_aurora_sg_group_id
  db_subnet_ids          = module.custom_vpc.database_subnets

  owners      = "matsuya"
  environment = "test"
}
*/
module "custom_ecs" {
  source = "./ecs"
  depends_on = [
    module.custom_vpc
  ]
  cluster_settings = {
    "name" : "containerInsights",
    "value" : "enabled"
  }
  proxy_port           = 80
  proxy_container_name = "nginx"
  fargate_cpu          = 256
  fargate_memory       = 512
  nginx_image_uri      = "528163014577.dkr.ecr.us-east-2.amazonaws.com/test/nginx"
  php_image_uri        = "528163014577.dkr.ecr.us-east-2.amazonaws.com/test/php"
  fluentbit_image_uri  = "528163014577.dkr.ecr.us-east-2.amazonaws.com/test/fluentbit"
  nginx_container_port = 80
  php_container_port   = 9000
  firelens_log_group   = "/aws/ecs/matsuyatest-firelens-logs"
  ecs_volume_name      = "log-volume"
  ecs_volume_path      = "/var/www/html/logs"

  alb_target_group_arns     = module.custom_vpc.target_group_arns
  fargate_security_group_id = module.custom_vpc.fargate_sg_group_id
  public_subnets_ids        = module.custom_vpc.public_subnets

  owners      = "matsuya"
  environment = "test"
  aws_region  = var.aws_region
}

module "custom_lambda" {
  source = "./lambda"
  depends_on = [
    module.custom_ecs
  ]
  ecs_cluster   = module.custom_ecs.ecs_cluster_name
  ecs_service   = module.custom_ecs.ecs_service_name
  sns_topic_arn = module.custom_sns.sns_topic_arn

  owners      = "matsuya"
  environment = "test"
}
module "custom_sns" {
  source         = "./sns"
  sns_topic_name = "${local.name}-sns-topic-${random_pet.this.id}"
  owners         = "matsuya"
  environment    = "test"
}

module "custom_sfn" {
  source = "./sfn"
  depends_on = [
    module.custom_ecs,
    module.custom_vpc
  ]
  ecs_cluster_name                        = module.custom_ecs.ecs_cluster_name
  ecs_task_definition_import_licenses_arn = module.custom_ecs.aws_ecs_import_license_task_definition_arn
  ecs_task_definition_export_rds_arn      = module.custom_ecs.aws_ecs_export_rds_task_definition_arn
  public_subnets                          = module.custom_vpc.public_subnets
  fargate_security_group_id               = module.custom_vpc.fargate_sg_group_id
  import_licenses_task_role_arn           = module.custom_ecs.aws_ecs_import_license_task_role_arn
  import_licenses_task_execution_role_arn = module.custom_ecs.aws_ecs_import_license_task_execution_role_arn
  export_rds_task_role_arn                = module.custom_ecs.aws_ecs_export_rds_task_role_arn
  export_rds_task_execution_role_arn      = module.custom_ecs.aws_ecs_export_rds_task_execution_arn

  owners      = "matsuya"
  environment = "test"
}

module "custom_codepipeline" {
  source            = "./codepipeline"
  ecs_service_name  = module.custom_ecs.ecs_cluster_name
  ecs_cluster_name  = module.custom_ecs.ecs_cluster_name
  sns_topic_arn     = module.custom_sns.sns_subscription_arn
  full_repositoy_id = "ShotaroMatsuya/footle"

  owners      = "matsuya"
  environment = "test"
  aws_region  = var.aws_region
}

module "custom_codebuild" {
  source         = "./codebuild"
  buildspec_path = "copilot/pipelines/footle-copilot/buildspec.yml"

  owners         = "matsuya"
  environment    = "test"
  aws_region     = var.aws_region
  aws_account_id = var.aws_account_id
}

module "custom_chatbot" {
  source                     = "./chatbot"
  sns_topic_arn              = module.custom_sns.sns_topic_arn
  chatbot_slack_workspace_id = "T02RVJA3YDN"
  chatbot_slack_id           = "C02R8V82XDH"

  owners      = "matsuya"
  environment = "test"
}
