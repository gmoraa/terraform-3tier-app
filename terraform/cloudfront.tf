# Web Service CDN
resource "aws_cloudfront_distribution" "distribution" {
  origin {
    domain_name = aws_lb.lb_web.dns_name
    origin_id   = aws_lb.lb_web.id
    custom_origin_config {
        origin_protocol_policy = "http-only"
        http_port = 80
        https_port = 80
        origin_ssl_protocols = ["TLSv1"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    target_origin_id       = aws_lb.lb_web.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}