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

