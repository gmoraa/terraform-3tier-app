# ECS Web Service
resource "aws_ecs_service" "web_service" {
  name                               = "web"
  cluster                            = aws_ecs_cluster.cluster.id
  desired_count                      = 1
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  platform_version                   = "LATEST"
  task_definition                    = aws_ecs_task_definition.web_task.arn
  load_balancer {
    target_group_arn                 = aws_lb_target_group.lb_target_group_web.arn
    container_name                   = "web"
    container_port                   = 80
  }
  network_configuration {
    subnets                          = [ aws_default_subnet.default_az1.id ]
    assign_public_ip                 = true
    security_groups                  = [ aws_security_group.security_group_web_service.id ]
  }
}