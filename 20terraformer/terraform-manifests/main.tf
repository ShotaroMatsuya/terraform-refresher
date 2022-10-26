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

module "custom_rds" {
  source                 = "./rds"
  db_name                = data.external.aurora_credentials_json.result["dbname"]
  db_instance_identifier = "webappdb"
  db_username            = data.external.aurora_credentials_json.result["username"]
  db_password            = data.external.aurora_credentials_json.result["password"]
  db_security_group_ids  = module.custom_vpc.rds_aurora_sg_group_id
  db_subnet_ids          = module.custom_vpc.database_subnets

  owners      = "matsuya"
  environment = "test"
}
