# Get Secret Parameters from AWS SecretsManger

data "aws_secretsmanager_secret" "aurora_secret" {
  # secretsの名前
  name = "secret_manager_terraform_test"
}
data "aws_secretsmanager_secret_version" "aurora_secret" {
  secret_id = data.aws_secretsmanager_secret.aurora_secret.id
}

# terraform External Data Sourceを使ってSecretmanagerのJSONをデコードする

data "external" "aurora_credentials_json" {
  program = ["echo", "${data.aws_secretsmanager_secret_version.aurora_secret.secret_string}"]
}

output "aurora_credentials_db_name" {
  value = data.external.aurora_credentials_json.result["dbname"]
}

output "aurora_credentials_db_host" {
  value = data.external.aurora_credentials_json.result["host"]
}

output "aurora_credentials_db_username" {
  value = data.external.aurora_credentials_json.result["username"]
}

output "aurora_credentials_db_password" {
  value = data.external.aurora_credentials_json.result["password"]
}
