# Terraform Remote State Datasource
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraform-on-smat-aws"
    key    = "dev/project1-vpc/terraform.tfstate"
    region = "ap-northeast-1"
  }
}