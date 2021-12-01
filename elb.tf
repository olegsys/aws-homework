#----------------ELB------------------
resource "aws_lb_target_group" "wp-target_group" {
    name = "tg-wp-web"
    port = 80
    protocol = "TCP"
    target_type = "ip"
    vpc_id = aws_vpc.wordpress_a.id
    health_check {
      protocol = "HTTP"
      interval = 10
      port = 80
      healthy_threshold = 2
      unhealthy_threshold = 2
    }
}
resource "aws_lb_target_group_attachment" "wp-target-a" {
    target_group_arn = aws_lb_target_group.wp-target_group.arn
    target_id = aws_instance.wp-node-a.private_ip
    port = 80
}
resource "aws_lb_target_group_attachment" "wp-target-b" {
    target_group_arn = aws_lb_target_group.wp-target_group.arn
    target_id = aws_instance.wp-node-b.private_ip
    port = 80
    availability_zone = "all"
}
resource "aws_lb" "wp-elb" {
    name = "WP-ELB"
    internal = false
    load_balancer_type = "network"
    subnets = ["${aws_subnet.wordpress_a.id}"]
}
resource "aws_lb_listener" "wp-elb-listner" {
    load_balancer_arn = aws_lb.wp-elb.arn
    port = 80
    protocol = "TCP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.wp-target_group.arn
    }
    
}

resource "cloudflare_record" "olegsys" {
  zone_id = var.zone_id
  name    = "@"
  value   = aws_lb.wp-elb.dns_name
  type    = "CNAME"
  ttl     = 300
}
#----------------ELB------------------