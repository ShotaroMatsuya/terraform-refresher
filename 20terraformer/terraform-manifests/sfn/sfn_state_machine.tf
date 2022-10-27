# import-licenses-from-infrastructure
resource "aws_sfn_state_machine" "import_licenses_from_infra" {

  definition = <<EOF
{
  "Version": "1.0",
  "Comment": "Run AWS Fargate task",
  "TimeoutSeconds": 600,
  "StartAt": "Run Fargate Task",
  "States": {
    "Run Fargate Task": {
      "Type": "Task",
      "Resource": "arn:aws:states:::ecs:runTask.sync",
      "Parameters": {
        "LaunchType": "FARGATE",
        "PlatformVersion": "1.4.0",
        "Cluster": "${var.ecs_cluster_name}",
        "TaskDefinition": "${var.ecs_task_definition_import_licenses_arn}",
        "PropagateTags": "TASK_DEFINITION",
        "Group.$": "$$.Execution.Name",
        "NetworkConfiguration": {
          "AwsvpcConfiguration": {
            "Subnets": ${jsonencode(var.public_subnets)},
            "AssignPublicIp": "ENABLED",
            "SecurityGroups": ["${var.fargate_security_group_id}"]
          }
        }
      },
      "Retry": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "IntervalSeconds": 10,
          "MaxAttempts": 3,
          "BackoffRate": 1.5
        }
      ],
      "End": true
    }
  }
}
EOF
  logging_configuration {
    include_execution_data = "true"
    level                  = "ALL"
    log_destination        = "${aws_cloudwatch_log_group.import_licenses_cloudwatch_log_group.arn}:*"
  }

  name     = "${local.name}-import-licenses-from-infra"
  role_arn = aws_iam_role.import_licenses_state_machine_role.arn

  tags = local.common_tags

  tracing_configuration {
    enabled = "false"
  }

  type = "STANDARD"
}

resource "aws_cloudwatch_log_group" "import_licenses_cloudwatch_log_group" {
  name              = "/aws/${local.name}-import-licenses"
  retention_in_days = "14"

  tags = local.common_tags
}

# export-rds-to-s3
resource "aws_sfn_state_machine" "export_rds_to_s3" {
  definition = <<EOF
{
  "Version": "1.0",
  "Comment": "Run AWS Fargate task",
  "TimeoutSeconds": 600,
  "StartAt": "Run Fargate Task",
  "States": {
    "Run Fargate Task": {
      "Type": "Task",
      "Resource": "arn:aws:states:::ecs:runTask.sync",
      "Parameters": {
        "LaunchType": "FARGATE",
        "PlatformVersion": "1.4.0",
        "Cluster": "${var.ecs_cluster_name}",
        "TaskDefinition": "${var.ecs_task_definition_export_rds_arn}",
        "PropagateTags": "TASK_DEFINITION",
        "Group.$": "$$.Execution.Name",
        "NetworkConfiguration": {
          "AwsvpcConfiguration": {
            "Subnets": ${jsonencode(var.public_subnets)},
            "AssignPublicIp": "ENABLED",
            "SecurityGroups": ["${var.fargate_security_group_id}"]
          }
        }
      },
      "Retry": [{
        "ErrorEquals": [
            "States.ALL"
        ],
        "IntervalSeconds": 10,
        "MaxAttempts": 3,
        "BackoffRate": 1.5
      }],
      "End": true
    }
  }
}
EOF
  logging_configuration {
    include_execution_data = "true"
    level                  = "ALL"
    log_destination        = "${aws_cloudwatch_log_group.export_rds_to_s3_cloudwatch_log_group.arn}:*"
  }

  name     = "${local.name}-export-rds-to-s3"
  role_arn = aws_iam_role.export_rds_to_s3_state_machine_role.arn

  tags = local.common_tags

  tracing_configuration {
    enabled = "false"
  }
  type = "STANDARD"
}

resource "aws_cloudwatch_log_group" "export_rds_to_s3_cloudwatch_log_group" {
  name              = "/aws/${local.name}-export-rds-to-s3"
  retention_in_days = "14"

  tags = local.common_tags
}
