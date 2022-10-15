############################################################################
# Chatbot
############################################################################
# https://github.com/waveaccounting/terraform-aws-chatbot-slack-configuration
module "chatbot_slack_configuration" {
  source  = "waveaccounting/chatbot-slack-configuration/aws"
  version = "1.1.0"

  configuration_name = "${local.name}-chatbot"
  guardrail_policies = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  iam_role_arn       = aws_iam_role.chatbot-notification-only.arn
  slack_channel_id   = var.chatbot_slack_id
  slack_workspace_id = var.chatbot_slack_workspace_id
  sns_topic_arns     = [aws_sns_topic.main.arn]
  user_role_required = false
  tags               = local.common_tags
}

resource "aws_iam_role" "chatbot-notification-only" {
  name = "chatbot-notification-only"
  assume_role_policy = jsonencode(
    {
      Version : "2012-10-17",
      Statement : [
        {
          Sid : "",
          Effect : "Allow",
          Principal : {
            Service : "chatbot.amazonaws.com"
          },
          Action : "sts:AssumeRole"
        }
      ]
    }
  )
  description          = "AWS Chatbot Execution Role for Only Notification"
  max_session_duration = "3600"
  path                 = "/service-role/"
}

resource "aws_iam_role_policy_attachment" "chatbot-notification-only-attach" {
  policy_arn = aws_iam_policy.chatbot-notification-only.arn
  role       = aws_iam_role.chatbot-notification-only.name
}

resource "aws_iam_policy" "chatbot-notification-only" {
  name = "chatbot-notification-only"
  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement : [
        {
          Sid : "",
          Effect : "Allow",
          Action : [
            "cloudwatch:Describe*",
            "cloudwatch:Get*",
            "cloudwatch:List*"
          ],
          Resource : "*"
        }
      ]
    }
  )
}
