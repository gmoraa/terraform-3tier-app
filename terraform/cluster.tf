# ECS Cluster
resource "aws_ecs_cluster" "cluster" {
  name = "ecs_cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  lifecycle {
    ignore_changes = [
      setting,
    ]
  }
}