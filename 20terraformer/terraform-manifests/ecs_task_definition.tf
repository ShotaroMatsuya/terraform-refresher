resource "aws_cloudwatch_log_group" "firelens" {
  name              = var.firelens_log_group
  retention_in_days = 14
}

resource "aws_ecs_task_definition" "main" {
  container_definitions = jsonencode(
    [
      {
        cpu : 0,
        environment : [
          { name : "APP_NAME", value : "qb-medical_staff-cms" }
        ],
        essential : true,
        image : var.php_image_uri,
        logConfiguration : {
          logDriver : "awsfirelens"
        },
        mountPoints : [{
          containerPath : "/var/www/html/logs",
          sourceVolume : var.ecs_volume_name
        }],
        name : "cms",
        portMappings : [{
          containerPort : var.php_container_port,
          hostPort : var.php_container_port,
          protocol : "tcp"
        }],
      },
      {
        cpu : 0,
        essential : true,
        image : var.nginx_image_uri,
        logConfiguration : {
          logDriver : "awsfirelens"
        },
        name : "nginx",
        portMappings : [{
          containerPort : var.nginx_container_port,
          hostPort : var.nginx_container_port,
          protocol : "tcp"
        }],
      },
      {
        cpu : 0,
        essential : true,
        firelensConfiguration : {
          options : {
            config-file-type : "file",
            config-file-value : "/fluent-bit/etc/fluent-bit_custom.conf",
            enable-ecs-log-metadata : "true"
          },
          type : "fluentbit"
        },
        image : var.fluentbit_image_uri,
        logConfiguration : {
          logDriver : "awslogs",
          options : {
            awslogs-group : var.firelens_log_group,
            awslogs-region : var.aws_region,
            awslogs-stream-prefix : "firelens"
          }
        },
        mountPoints : [{
          containerPath : "/var/www/html/logs",
          sourceVolume : var.ecs_volume_name
        }],
        name : "firelens_log_router",
        user : "0",
      }
  ])

  cpu                      = var.fargate_cpu
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  family                   = local.name
  memory                   = var.fargate_memory
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.main_ecs_tasks.arn

  volume {
    name = var.ecs_volume_name
  }
}
