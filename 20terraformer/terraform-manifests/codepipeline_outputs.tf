output "codepipeline_arn" {
  description = ""
  value       = aws_codepipeline.main.arn
}

output "codepipeline_id" {
  description = ""
  value       = aws_codepipeline.main.id
}

output "codepipeline_artifacts_bucket_id" {
  description = ""
  value       = aws_s3_bucket.artifact.id
}

output "codepipeline_artifacts_bucket_arn" {
  description = ""
  value       = aws_s3_bucket.artifact.arn
}

output "codepipeline_artifacts_bucket_name" {
  description = ""
  value       = aws_s3_bucket.artifact.bucket
}

output "codepieline_serice_role_arn" {
  description = ""
  value       = aws_iam_role.PipelineRole.arn
}

output "codestarconnections_id" {
  description = "The codestar connection ARN."
  value       = aws_codestarconnections_connection.main.id
}
output "codestarconnections_arn" {
  description = "The codestar connection ARN."
  value       = aws_codestarconnections_connection.main.arn
}
