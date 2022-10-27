output "ecs_cluster_id" {
  description = "ARN that identifies the cluster"
  value       = aws_ecs_cluster.main.id
}

output "ecs_cluster_name" {
  description = "Name of the cluster."
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_id" {
  description = "ARN that identifies the service."
  value       = aws_ecs_service.main.id
}

output "ecs_service_disired_count" {
  description = "Number of instances of the task definition."
  value       = aws_ecs_service.main.desired_count
}

output "ecs_service_associated_alb_iam" {
  description = "ARN of IAM role used for ELB."
  value       = aws_ecs_service.main.iam_role
}

output "ecs_service_name" {
  description = "Name of the service."
  value       = aws_ecs_service.main.name
}

output "aws_ecs_main_task_definition_arn" {
  description = "Full ARN of the Main Task Definition (including both family and revision)."
  value       = aws_ecs_task_definition.main.arn
}

output "aws_ecs_main_task_definition_revision" {
  description = "Revision of the task in a particular family."
  value       = aws_ecs_task_definition.main.revision
}

output "aws_ecs_import_license_task_definition_arn" {
  description = "Full ARN of the import_licenses jobs Task Definition (including both family and revision)."
  value       = aws_ecs_task_definition.import_licenses_from_infra.arn
}
output "aws_ecs_export_rds_task_definition_arn" {
  description = "Full ARN of the export_rds jobs Task Definition (including both family and revision)."
  value       = aws_ecs_task_definition.export_rds_to_s3.arn
}

output "aws_cloudwatch_firelens_log_group_id" {
  value = aws_cloudwatch_log_group.firelens.id
}

output "aws_ecs_import_license_task_role_arn" {
  description = "ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services."
  value       = aws_iam_role.import_licenses_task_role.arn
}
output "aws_ecs_import_license_task_execution_role_arn" {
  description = "ARN of the task execution role that the Amazon ECS container agent and the Docker daemon can assume."
  value       = aws_iam_role.import_licenses_task_execution_role.arn
}

output "aws_ecs_export_rds_task_role_arn" {
  description = "ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services."
  value       = aws_iam_role.export_rds_to_s3_task_role.arn
}
output "aws_ecs_export_rds_task_execution_arn" {
  description = "ARN of the task execution role that the Amazon ECS container agent and the Docker daemon can assume."
  value       = aws_iam_role.export_rds_to_s3_task_execution_role.arn
}
