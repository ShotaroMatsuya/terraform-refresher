output "import_licenses_state_machine_arn" {
  value = aws_sfn_state_machine.import_licenses_from_infra.arn
}

output "export_rds_to_s3_state_machine_arn" {
  value = aws_sfn_state_machine.export_rds_to_s3.arn
}
