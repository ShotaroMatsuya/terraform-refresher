
resource "aws_cloudwatch_event_rule" "export_rds_to_s3_Rule" {
  event_bus_name      = "default"
  is_enabled          = "true"
  name                = "${local.name}-export-rds-to-s3"
  schedule_expression = "cron(0 15 * * ? *)"
}

resource "aws_cloudwatch_event_rule" "import_licenses_Rule" {
  event_bus_name      = "default"
  is_enabled          = "true"
  name                = "${local.name}-import-licenses"
  schedule_expression = "cron(40 16 * * ? *)"
}

resource "aws_cloudwatch_event_target" "export_rds_to_s3_statemachine_target" {
  arn      = aws_sfn_state_machine.export_rds_to_s3.arn
  role_arn = aws_iam_role.export_rds_to_s3_RuleRole.arn
  rule     = aws_cloudwatch_event_rule.export_rds_to_s3_Rule.name
}

resource "aws_cloudwatch_event_target" "import_licenses_statemachine_target" {
  arn      = aws_sfn_state_machine.import_licenses_from_infra.arn
  role_arn = aws_iam_role.import_licenses_RuleRole.arn
  rule     = aws_cloudwatch_event_rule.import_licenses_Rule.name
}

resource "aws_iam_role" "export_rds_to_s3_RuleRole" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      }
    }
  ],
  "Version": "2008-10-17"
}
POLICY

  inline_policy {
    name   = "EventRulePolicy"
    policy = <<POLICY
{
  "Statement":[
    {
      "Action":"states:StartExecution",
      "Resource":"*",
      "Effect":"Allow"
    }
  ]
}
POLICY
  }

  max_session_duration = "3600"
  name                 = "${local.name}-export-rds-to-s3-RuleRole"
  path                 = "/"

  tags = local.common_tags
}
resource "aws_iam_role_policy" "export_rds_to_s3_RulePolicy" {
  name = "EventRulePolicy"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "states:StartExecution",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
POLICY

  role = aws_iam_role.export_rds_to_s3_RuleRole.name
}

resource "aws_iam_role" "import_licenses_RuleRole" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      }
    }
  ],
  "Version": "2008-10-17"
}
POLICY

  inline_policy {
    name   = "EventRulePolicy"
    policy = <<POLICY
{
  "Statement":[
    {
      "Action":"states:StartExecution",
      "Resource":"*",
      "Effect":"Allow"
    }
  ]
}
POLICY
  }

  max_session_duration = "3600"
  name                 = "${local.name}-import-licenses-RuleRole"
  path                 = "/"

  tags = local.common_tags

}

resource "aws_iam_role_policy" "import_licenses_RulePolicy" {
  name = "EventRulePolicy"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "states:StartExecution",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
POLICY

  role = aws_iam_role.import_licenses_RuleRole.name
}
