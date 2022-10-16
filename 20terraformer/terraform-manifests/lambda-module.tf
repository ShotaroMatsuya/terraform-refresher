module "fargate-start-function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "4.1.1"
  depends_on = [
    aws_ecs_service.main
  ]
  function_name          = "${random_pet.this.id}-fargate-start-${local.name}"
  description            = "My awesome lambda function"
  handler                = "start.lambda_handler"
  runtime                = "python3.9"
  ephemeral_storage_size = 512
  architectures          = ["x86_64"]
  publish                = true

  source_path = ["${path.module}/fixtures/python3.9/start.py"]

  environment_variables = {
    ECS_SERVICE        = aws_ecs_service.main.name
    ECS_CLUSTER        = aws_ecs_cluster.main.name
    CWA_TASK_COUNT     = var.task_count_alarm_name
    CWA_SERVICE_CPU    = var.service_cpu_alarm_name
    CWA_SERVICE_MEMORY = var.service_memory_alarm_name
  }
}

module "fargate-stop-function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "4.1.1"
  depends_on = [
    aws_ecs_service.main
  ]
  function_name          = "${random_pet.this.id}-fargate-stop-${local.name}"
  description            = "My awesome lambda function"
  handler                = "stop.lambda_handler"
  runtime                = "python3.9"
  ephemeral_storage_size = 512
  architectures          = ["x86_64"]
  publish                = true

  source_path = ["${path.module}/fixtures/python3.9/stop.py"]

  environment_variables = {
    ECS_SERVICE        = aws_ecs_service.main.name
    ECS_CLUSTER        = aws_ecs_cluster.main.name
    CWA_TASK_COUNT     = var.task_count_alarm_name
    CWA_SERVICE_CPU    = var.service_cpu_alarm_name
    CWA_SERVICE_MEMORY = var.service_memory_alarm_name
  }
}

