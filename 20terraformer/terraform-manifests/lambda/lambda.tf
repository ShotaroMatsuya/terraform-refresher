module "fargate-start-function" {
  source                 = "terraform-aws-modules/lambda/aws"
  version                = "4.1.1"
  function_name          = "${local.name}-fargate-start"
  description            = "My awesome lambda function"
  handler                = "start.lambda_handler"
  runtime                = "python3.9"
  ephemeral_storage_size = 512
  architectures          = ["x86_64"]
  publish                = true

  source_path = ["${path.module}/fixtures/python3.9/start.py"]

  environment_variables = {
    ECS_SERVICE        = var.ecs_service
    ECS_CLUSTER        = var.ecs_cluster
    CWA_TASK_COUNT     = aws_cloudwatch_metric_alarm.task_running_count.alarm_name
    CWA_SERVICE_CPU    = aws_cloudwatch_metric_alarm.cpu_utilization.alarm_name
    CWA_SERVICE_MEMORY = aws_cloudwatch_metric_alarm.memory_utilization.alarm_name
  }
}

module "fargate-stop-function" {
  source                 = "terraform-aws-modules/lambda/aws"
  version                = "4.1.1"
  function_name          = "${local.name}-fargate-stop"
  description            = "My awesome lambda function"
  handler                = "stop.lambda_handler"
  runtime                = "python3.9"
  ephemeral_storage_size = 512
  architectures          = ["x86_64"]
  publish                = true

  source_path = ["${path.module}/fixtures/python3.9/stop.py"]

  environment_variables = {
    ECS_SERVICE        = var.ecs_service
    ECS_CLUSTER        = var.ecs_cluster
    CWA_TASK_COUNT     = aws_cloudwatch_metric_alarm.task_running_count.alarm_name
    CWA_SERVICE_CPU    = aws_cloudwatch_metric_alarm.cpu_utilization.alarm_name
    CWA_SERVICE_MEMORY = aws_cloudwatch_metric_alarm.memory_utilization.alarm_name
  }
}

