# ECS Input Variables
# ECS Cluster Name
variable "cluster_settings" {
  description = "Configuration block(s) with cluster settings. For example, this can be used to enable CloudWatch Container Insights for a cluster"
  type        = map(string)
  default = {
    "name" : "containerInsights",
    "value" : "enabled"
  }
}

variable "proxy_port" {
  description = ""
  type        = string
  default     = "80"
}

variable "proxy_container_name" {
  description = ""
  type        = string
  default     = "nginx"
}

variable "fargate_cpu" {
  type        = number
  description = "Fargate Cpu allocation"
  default     = 256
}

variable "fargate_memory" {
  type        = number
  description = "Fargate Memory allocation"
  default     = 512
}

variable "nginx_image_uri" {
  type    = string
  default = "528163014577.dkr.ecr.us-east-2.amazonaws.com/test/nginx"
}

variable "php_image_uri" {
  type    = string
  default = "528163014577.dkr.ecr.us-east-2.amazonaws.com/test/php"
}

variable "fluentbit_image_uri" {
  type    = string
  default = "528163014577.dkr.ecr.us-east-2.amazonaws.com/test/fluentbit"
}

variable "nginx_container_port" {
  type    = number
  default = 80
}

variable "php_container_port" {
  type    = number
  default = 9000
}

variable "firelens_log_group" {
  type    = string
  default = "/aws/ecs/matsuyatest-firelens-logs"
}

variable "ecs_volume_name" {
  type    = string
  default = "log-volume"
}
