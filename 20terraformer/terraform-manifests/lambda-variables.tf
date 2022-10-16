# cloudwatch alarm
variable "task_count_alarm_name" {
  default = "task_count"
}
variable "service_cpu_alarm_name" {
  default = "service_cpu"
}
variable "service_memory_alarm_name" {
  default = "service_memory"
}

# ecs 
# variable "ecs_cluster_name" {
#   default = aws_ecs_cluster.main.name
# }

# variable "ecs_service_name" {
#   default = aws_ecs_service.main.name
# }
