# ECS API Service
resource "aws_ecs_service" "api_service" {
  name                               = "api"
  cluster                            = aws_ecs_cluster.cluster.id
  desired_count                      = 1
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  platform_version                   = "LATEST"
  task_definition                    = aws_ecs_task_definition.api_task.arn
  load_balancer {
    target_group_arn                 = aws_lb_target_group.lb_target_group_api.arn
    container_name                   = "api"
    container_port                   = 3000
  }
  network_configuration {
    subnets                          = [ aws_default_subnet.default_az1.id ]
    assign_public_ip                 = true
    security_groups                  = [ aws_security_group.security_group_api_service.id ]
  }
}