# Pull ECR Web Image
data "aws_ecr_image" "aws_ecr_image_web" {
  repository_name              = "web"
  image_tag                    = "9"
  registry_id                  = "129484386859"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "web_task" {
  family                       = "web"
  requires_compatibilities     = ["FARGATE"]
  task_role_arn                = ""
  execution_role_arn           = "${aws_iam_role.ecs_task_execution_role.arn}"
  cpu                          = "256"
  memory                       = "1024"
  network_mode                 = "awsvpc"

  container_definitions        = jsonencode([
    {
      name                     = "web"
      image                    = "129484386859.dkr.ecr.us-east-1.amazonaws.com/web:latest@${data.aws_ecr_image.aws_ecr_image_web.image_digest}"
      portMappings             = [
        {
          "containerPort":80,
          "hostPort":80,
          "protocol":"tcp"
        },
      ],
      logConfiguration = {
        "logDriver": "awslogs",
          "options": {
            "awslogs-region" : "us-east-1",
            "awslogs-group" : "web-log-group",
            "awslogs-stream-prefix" : "web"
          }
      },
      environment              = [
        {
          "name":"PORT",
          "value":"80"
        },
        {
          "name":"API_HOST",
          "value":"http://${aws_lb.lb_api.dns_name}:3000"
        }
      ],
      cpu                      = 10
      memory                   = 512
      essential                = true
    }
  ])
}