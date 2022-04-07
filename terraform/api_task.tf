# Pull ECR API Image
data "aws_ecr_image" "aws_ecr_image_api" {
  repository_name              = "api"
  image_tag                    = "9"
  registry_id                  = "129484386859"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "api_task" {
  family                       = "api"
  requires_compatibilities     = ["FARGATE"]
  task_role_arn                = ""
  execution_role_arn           = "${aws_iam_role.ecs_task_execution_role.arn}"
  cpu                          = "256"
  memory                       = "1024"
  network_mode                 = "awsvpc"

  container_definitions        = jsonencode([
    {
      name                     = "api"
      image                    = "129484386859.dkr.ecr.us-east-1.amazonaws.com/api:latest@${data.aws_ecr_image.aws_ecr_image_api.image_digest}"
      portMappings             = [
        {
          "containerPort":3000,
          "hostPort":3000,
          "protocol":"tcp"
        },
      ],
      logConfiguration = {
        "logDriver": "awslogs",
          "options": {
            "awslogs-region" : "us-east-1",
            "awslogs-group" : "api-log-group",
            "awslogs-stream-prefix" : "api"
          }
      },
      environment              = [
        {
          "name":"PORT",
          "value":"3000"
        },
        {
          "name":"DB",
          "value":"${aws_db_instance.aws_db_instance_rdsdb.db_name}"
        },
        {
          "name":"DBUSER",
          "value":"${local.db_creds.username}"
        },
        {
          "name":"DBPASS",
          "value":"${local.db_creds.password}"
        },
        {
          "name":"DBHOST",
          "value":"${aws_db_instance.aws_db_instance_rdsdb.address}"
        },
        {
          "name":"DBPORT",
          "value":"5432"
        }
      ],
      cpu                      = 10
      memory                   = 512
      essential                = true
    }
  ])
}