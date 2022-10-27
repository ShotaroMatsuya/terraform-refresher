import logging
import os

import boto3


def get_schedule_logger():
    log_format = '[cms-schedule-%(levelname)s][%(aws_request_id)s][%(funcName)s:%(lineno)d]\t%(message)s'
    formatter = logging.Formatter(log_format)
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    for handler in logger.handlers:
        handler.setFormatter(formatter)
        return logger


logger = get_schedule_logger()


def control_cloudwatch_alarm():
    client = boto3.client('cloudwatch')

    try:
        client.disable_alarm_actions(
            # 無効化するCloudwatchアラーム名
            AlarmNames=[
                os.environ["CWA_TASK_COUNT"],
                os.environ["CWA_SERVICE_CPU"],
                os.environ["CWA_SERVICE_MEMORY"]
            ]
        )
        logger.info("Enabling CloudWatch Alarm")
    except Exception as e:
        logger.error("Exception: {}".format(e))


def control_ecs_cluster():
    client = boto3.client('ecs')
    # 停止するECS クラスターとサービスを指定
    try:
        for cluster_name, service_name in [(os.environ["ECS_CLUSTER"], os.environ["ECS_SERVICE"])]:
            service_update_result = client.update_service(
                cluster=cluster_name,
                service=service_name,
                desiredCount=0
            )
            logger.info(service_update_result)
    except Exception as e:
        logger.error("Exception: {}".format(e))


def lambda_handler(event, context):

    control_ecs_cluster()
    control_cloudwatch_alarm()
