resource "aws_iam_role" "import_licenses_state_machine_role" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "states.amazonaws.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  inline_policy {
    name   = "StateMachine"
    policy = <<POLICY
{
   "Statement":[
      {
         "Action":"iam:PassRole",
         "Resource":[
            "${var.import_licenses_task_role_arn}",
            "${var.import_licenses_task_execution_role_arn}"
         ],
         "Effect":"Allow"
      },
      {
         "Action":[
            "logs:CreateLogDelivery",
            "logs:GetLogDelivery",
            "logs:UpdateLogDelivery",
            "logs:DeleteLogDelivery",
            "logs:ListLogDeliveries",
            "logs:PutResourcePolicy",
            "logs:DescribeResourcePolicies",
            "logs:DescribeLogGroups"
         ],
         "Resource":"*",
         "Effect":"Allow"
      },
      {
         "Action":[
            "events:PutTargets",
            "events:PutRule",
            "events:DescribeRule"
         ],
         "Resource":"*",
         "Effect":"Allow"
      },
      {
         "Action":[
            "ecs:RunTask",
            "ecs:StopTask",
            "ecs:DescribeTasks"
         ],
         "Effect":"Allow",
         "Resource":"*"
      }
   ]
}
POLICY
  }

  max_session_duration = "3600"
  name                 = "${local.name}-import-licenses-StateMachineRole"
  path                 = "/"

  tags = local.common_tags

}

resource "aws_iam_role" "export_rds_to_s3_state_machine_role" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "states.amazonaws.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  inline_policy {
    name   = "StateMachine"
    policy = <<POLICY
{
   "Statement":[
      {
         "Action":"iam:PassRole",
         "Resource":[
            "${var.export_rds_task_role_arn}",
            "${var.export_rds_task_execution_role_arn}"
         ],
         "Effect":"Allow"
      },
      {
         "Action":[
            "logs:CreateLogDelivery",
            "logs:GetLogDelivery",
            "logs:UpdateLogDelivery",
            "logs:DeleteLogDelivery",
            "logs:ListLogDeliveries",
            "logs:PutResourcePolicy",
            "logs:DescribeResourcePolicies",
            "logs:DescribeLogGroups"
         ],
         "Resource":"*",
         "Effect":"Allow"
      },
      {
         "Action":[
            "events:PutTargets",
            "events:PutRule",
            "events:DescribeRule"
         ],
         "Resource":"*",
         "Effect":"Allow"
      },
      {
         "Action":[
            "ecs:RunTask",
            "ecs:StopTask",
            "ecs:DescribeTasks"
         ],
         "Effect":"Allow",
         "Resource":"*"
      }
   ]
}
POLICY
  }

  max_session_duration = "3600"
  name                 = "${local.name}-export-rds-to-s3-StateMachineRole"
  path                 = "/"

  tags = local.common_tags

}
