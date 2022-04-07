# API Security Group
resource "aws_security_group" "security_group_api_service" {
  description       = "SG for api service"
  name              = "api-service"
  vpc_id            = "${aws_default_vpc.default.id}"
  ingress {
    cidr_blocks     = ["0.0.0.0/0"]
    from_port       = 3000
    protocol        = "tcp"
    to_port         = 3000
  }
  egress {
    from_port       = 0
    to_port         = 0
    cidr_blocks     = ["0.0.0.0/0"]
    protocol        = "-1"
  }
}

# Web Security Group
resource "aws_security_group" "security_group_web_service" {
  description       = "SG for web service"
  name              = "web-service"
  vpc_id            = "${aws_default_vpc.default.id}"
  ingress {
    cidr_blocks     = ["0.0.0.0/0"]
    from_port       = 80
    protocol        = "tcp"
    to_port         = 80
  }
  egress {
    from_port       = 0
    to_port         = 0
    cidr_blocks     = ["0.0.0.0/0"]
    protocol        = "-1"
  }
}

# RDS Security Group
resource "aws_security_group" "security_group_rds" {
  description       = "SG for RDS"
  name              = "rds"
  vpc_id            = "${aws_default_vpc.default.id}"
  ingress {
    security_groups = [ aws_security_group.security_group_api_service.id ]
    from_port       = 5432
    protocol        = "tcp"
    to_port         = 5432
  }
}