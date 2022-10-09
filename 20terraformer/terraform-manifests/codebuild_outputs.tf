output "codebuild_arn" {
  description = ""
  value       = aws_codebuild_project.main.arn
}

output "codebuild_id" {
  description = ""
  value       = aws_codebuild_project.main.id
}

output "codebuild_service_role_arn" {
  description = ""
  value       = aws_iam_role.BuildProjectRole.arn
}
