resource "aws_cloudwatch_event_target" "fargate_start_target" {
  arn  = module.fargate-start-function.lambda_function_arn
  rule = aws_cloudwatch_event_rule.fargate_start.name
}

resource "aws_cloudwatch_event_target" "fargate_stop_target" {
  arn  = module.fargate-stop-function.lambda_function_arn
  rule = aws_cloudwatch_event_rule.fargate_stop.name
}

resource "aws_cloudwatch_event_rule" "fargate_start" {
  description         = "fargateを起動"
  event_bus_name      = "default"
  is_enabled          = "true"
  name                = "${local.name}-fargate-start"
  schedule_expression = "cron(0 1 ? * MON-FRI *)"
}

resource "aws_cloudwatch_event_rule" "fargate_stop" {
  description         = "fargateを停止する"
  event_bus_name      = "default"
  is_enabled          = "true"
  name                = "${local.name}-fargate-stop"
  schedule_expression = "cron(00 10 ? * MON-FRI *)"
}
