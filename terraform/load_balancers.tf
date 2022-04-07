# API Load Balancer
resource "aws_lb" "lb_api" {
  name = "api-lb"
  internal = false
  load_balancer_type = "application"
  subnets = [ aws_default_subnet.default_az1.id,aws_default_subnet.default_az2.id ]
  security_groups = [ "${aws_security_group.security_group_api_service.id}" ]
  ip_address_type = "ipv4"
  access_logs {
    enabled = "false"
    bucket = ""
    prefix = ""
  }
  idle_timeout = "60"
  enable_deletion_protection = "false"
  enable_http2 = "true"
}

# API Target Group
resource "aws_lb_target_group" "lb_target_group_api" {
  health_check {
    interval = 30
    path = "/api/status"
    port = "traffic-port"
    protocol = "HTTP"
    timeout = 5
    unhealthy_threshold = 2
    healthy_threshold = 5
    matcher = "200"
  }
  port = 3000
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = "${aws_default_vpc.default.id}"
  name = "api-tg"
}

# API Listener
resource "aws_lb_listener" "lb_listener_api" {
  load_balancer_arn = aws_lb.lb_api.arn
  port = 3000
  protocol = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.lb_target_group_api.arn
    type = "forward"
  }
}

# Web Load Balancer
resource "aws_lb" "lb_web" {
  name = "web-lb"
  internal = false
  load_balancer_type = "application"
  subnets = [ aws_default_subnet.default_az1.id,aws_default_subnet.default_az2.id ]
  security_groups = [ "${aws_security_group.security_group_web_service.id}" ]
  ip_address_type = "ipv4"
  access_logs {
    enabled = "false"
    bucket = ""
    prefix = ""
  }
  idle_timeout = "60"
  enable_deletion_protection = "false"
  enable_http2 = "true"
}

# Web Target Group
resource "aws_lb_target_group" "lb_target_group_web" {
  health_check {
    interval = 30
    path = "/"
    port = "traffic-port"
    protocol = "HTTP"
    timeout = 5
    unhealthy_threshold = 2
    healthy_threshold = 5
    matcher = "200"
  }
  port = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = "${aws_default_vpc.default.id}"
  name = "web-tg"
}

# Web Listener
resource "aws_lb_listener" "lb_listener_web" {
  load_balancer_arn = aws_lb.lb_web.arn
  port = 80
  protocol = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.lb_target_group_web.arn
    type = "forward"
  }
}