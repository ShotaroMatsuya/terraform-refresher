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
          containerPath : var.ecs_volume_path,
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
          containerPath : var.ecs_volume_path,
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

resource "aws_ecs_task_definition" "import_licenses_from_infra" {
  container_definitions    = "[{\"command\":[],\"cpu\":0,\"dnsSearchDomains\":[],\"dnsServers\":[],\"dockerLabels\":{},\"dockerSecurityOptions\":[],\"entryPoint\":[\"/var/www/html/bin/cake\",\"import_licenses_from_infrastructure\"],\"environment\":[{\"name\":\"APP_NAME\",\"value\":\"nsqb-cms-batch\"},{\"name\":\"AWS_CREDENTIALS_KEY\",\"value\":\"AKIAT4AKFWEQAK3ICGBZ\"},{\"name\":\"AWS_CREDENTIALS_SECRET\",\"value\":\"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\"},{\"name\":\"CF_DISTRIBUTION_CBT_ID\",\"value\":\"E31AETSP30YNEJ\"},{\"name\":\"COPILOT_APPLICATION_NAME\",\"value\":\"nsqb-cms\"},{\"name\":\"COPILOT_ENVIRONMENT_NAME\",\"value\":\"dev\"},{\"name\":\"COPILOT_SERVICE_DISCOVERY_ENDPOINT\",\"value\":\"dev.nsqb-cms.local\"},{\"name\":\"COPILOT_SERVICE_NAME\",\"value\":\"import-licenses-from-infrastructure\"},{\"name\":\"DATABASE_HOST\",\"value\":\"qb-medical-staff-aurora-dev.cluster-ce2dwuc1flgz.ap-northeast-1.rds.amazonaws.com\"},{\"name\":\"DATABASE_NAME\",\"value\":\"nsqb\"},{\"name\":\"DATABASE_PASSWORD\",\"value\":\"{I)}x6PYA{\"},{\"name\":\"DATABASE_PORT\",\"value\":\"5432\"},{\"name\":\"DATABASE_USERNAME\",\"value\":\"nsqb\"},{\"name\":\"DEBUG\",\"value\":\"false\"},{\"name\":\"ENV_STRING\",\"value\":\"dev\"},{\"name\":\"MEDILINK_INFRA_DOMAIN\",\"value\":\"stg-accounts.console-medilink.com\"},{\"name\":\"QB_ONLINE_ADMIN_SYSTEM_ENV\",\"value\":\"development\"}],\"environmentFiles\":[],\"essential\":true,\"extraHosts\":[],\"image\":\"266309316896.dkr.ecr.ap-northeast-1.amazonaws.com/nsqb-cms/import-licenses-from-infrastructure@sha256:e5fffcb64408ef07a358c7d8bc26441e829e2c34262c8f7ad6e69fb3ed8b9581\",\"links\":[],\"logConfiguration\":{\"logDriver\":\"awslogs\",\"options\":{\"awslogs-group\":\"/copilot/nsqb-cms-dev-import-licenses-from-infrastructure\",\"awslogs-region\":\"ap-northeast-1\",\"awslogs-stream-prefix\":\"copilot\"},\"secretOptions\":[]},\"mountPoints\":[],\"name\":\"import-licenses-from-infrastructure\",\"portMappings\":[],\"secrets\":[],\"systemControls\":[],\"ulimits\":[],\"volumesFrom\":[]}]"
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.import_licenses_task_execution_role.arn
  family                   = "${local.name}-import-licenses-from-infra"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  tags = local.common_tags

  task_role_arn = aws_iam_role.import_licenses_task_role.arn
}

resource "aws_ecs_task_definition" "export_rds_to_s3" {
  container_definitions    = "[{\"command\":[],\"cpu\":0,\"dnsSearchDomains\":[],\"dnsServers\":[],\"dockerLabels\":{},\"dockerSecurityOptions\":[],\"entryPoint\":[],\"environment\":[{\"name\":\"COPILOT_APPLICATION_NAME\",\"value\":\"nsqb-cms\"},{\"name\":\"COPILOT_ENVIRONMENT_NAME\",\"value\":\"dev\"},{\"name\":\"COPILOT_SERVICE_DISCOVERY_ENDPOINT\",\"value\":\"dev.nsqb-cms.local\"},{\"name\":\"COPILOT_SERVICE_NAME\",\"value\":\"export-rds-to-s3\"},{\"name\":\"ENV_STRING\",\"value\":\"dev\"},{\"name\":\"POSTGRES_DB\",\"value\":\"nsqb\"},{\"name\":\"POSTGRES_DB_HOST\",\"value\":\"qb-medical-staff-aurora-dev.cluster-ce2dwuc1flgz.ap-northeast-1.rds.amazonaws.com\"},{\"name\":\"POSTGRES_PASSWORD\",\"value\":\"{I)}x6PYA{\"},{\"name\":\"POSTGRES_USER\",\"value\":\"nsqb\"},{\"name\":\"S3_BUCKET_NAME\",\"value\":\"nsqb-dev-datalake\"}],\"environmentFiles\":[],\"essential\":true,\"extraHosts\":[],\"image\":\"266309316896.dkr.ecr.ap-northeast-1.amazonaws.com/nsqb-cms/export-rds-to-s3@sha256:b964a72e4481aaf48a90443bd54d58eb9c26f0f8a15a8ffab4ac9195e56d607d\",\"links\":[],\"logConfiguration\":{\"logDriver\":\"awslogs\",\"options\":{\"awslogs-group\":\"/copilot/nsqb-cms-dev-export-rds-to-s3\",\"awslogs-region\":\"ap-northeast-1\",\"awslogs-stream-prefix\":\"copilot\"},\"secretOptions\":[]},\"mountPoints\":[],\"name\":\"export-rds-to-s3\",\"portMappings\":[],\"secrets\":[],\"systemControls\":[],\"ulimits\":[],\"volumesFrom\":[]}]"
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.export_rds_to_s3_task_execution_role.arn
  family                   = "${local.name}-export-rds-to-s3"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  tags = local.common_tags

  task_role_arn = aws_iam_role.export_rds_to_s3_task_role.arn

}
