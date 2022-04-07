# CloudWatch API LogGroup
resource "aws_cloudwatch_log_group" "api-log-group" {
  name = "api-log-group"
}

# CloudWatch Web LogGroup
resource "aws_cloudwatch_log_group" "web-log-group" {
  name = "web-log-group"
}