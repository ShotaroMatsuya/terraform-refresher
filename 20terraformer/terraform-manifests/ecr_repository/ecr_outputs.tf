output "fluentbit_repository_name" {
  description = ""
  value       = aws_ecr_repository.firelens-fluentbit.name
}
output "fluentbit_repository_arn" {
  description = ""
  value       = aws_ecr_repository.firelens-fluentbit.arn
}
output "fluentbit_repository_url" {
  description = ""
  value       = aws_ecr_repository.firelens-fluentbit.repository_url
}

output "php_repository_name" {
  description = ""
  value       = aws_ecr_repository.php.name
}
output "php_repository_arn" {
  description = ""
  value       = aws_ecr_repository.php.arn
}
output "php_repository_url" {
  description = ""
  value       = aws_ecr_repository.php.repository_url
}

output "nginx_repository_name" {
  description = ""
  value       = aws_ecr_repository.nginx.name
}
output "nginx_repository_arn" {
  description = ""
  value       = aws_ecr_repository.nginx.arn
}
output "nginx_repository_url" {
  description = ""
  value       = aws_ecr_repository.nginx.repository_url
}
