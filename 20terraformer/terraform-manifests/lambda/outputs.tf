# Lambda Function
output "lambda_start_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = module.fargate-start-function.lambda_function_arn
}
output "lambda_stop_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = module.fargate-stop-function.lambda_function_arn
}

output "lambda_start_function_name" {
  description = "The name of the Lambda Function"
  value       = module.fargate-start-function.lambda_function_name
}
output "lambda_stop_function_name" {
  description = "The name of the Lambda Function"
  value       = module.fargate-stop-function.lambda_function_name
}


output "cloudwatch_alarm_task_count_arn" {
  value = aws_cloudwatch_metric_alarm.task_running_count.arn
}

output "cloudwatch_alarm_cpu_utilization_arn" {
  value = aws_cloudwatch_metric_alarm.cpu_utilization.arn
}

output "cloudwatch_alarm_memory_utilization_arn" {
  value = aws_cloudwatch_metric_alarm.memory_utilization.arn
}
