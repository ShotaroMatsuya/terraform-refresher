# Terraform AWS Application Load Balancer (ALB)
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "8.0.0"

  name               = "${local.name}-alb"
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id

  subnets         = module.vpc.public_subnets
  security_groups = [module.loadbalancer_sg.security_group_id]
  # Listeners
  # HTTP Listener - HTTP to HTTPS Redirect
  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]
  # Target Groups
  target_groups = [
    # ECS service Target Group - TG Index = 0
    {
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "ip"
      deregistration_delay = 300
      health_check = {
        enabled             = true
        interval            = 6
        path                = "/healthcheck.html"
        port                = "traffic-port"
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 5
        protocol            = "HTTP"
        matcher             = "200"
      }
      protocol_version = "HTTP1"
      # targets = {
      #   my_ec2 = {
      #     target_id = aws_instance.this.id
      #     port      = 80
      #   },
      #   my_ec2_again = {
      #     target_id = aws_instance.this.id
      #     port      = 8080
      #   }
      # }
      tags = local.common_tags
    }
  ]

  # HTTPS Listener
  https_listeners = [
    # HTTPS listener index = 0 for HTTPS 443
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = module.acm.acm_certificate_arn
      target_group_index = 0
    }
  ]

  # HTTPS Lisntener Rules
  https_listener_rules = [
    # Rule-1: /app1* should go to ECS service
    {
      https_listener_index = 0
      priority             = 1
      actions = [
        {
          type               = "forward"
          target_group_index = 0
          stickiness = {
            enabled  = false
            duration = 86400
          }
        },
      ]
      conditions = [{
        path_patterns = ["/*"]
      }]
    }
  ]

  tags = local.common_tags
}
