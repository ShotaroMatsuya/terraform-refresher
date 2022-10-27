resource "aws_ecs_cluster" "main" {
  capacity_providers = ["FARGATE"]

  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }

  name = "${local.name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = local.common_tags
}
