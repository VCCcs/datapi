resource "aws_lb_target_group" "front" {
  name     = "adult-api"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.data_vpc_main.id
  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 10
    matcher             = 200
    path                = "/ping"
    port                = 8000
    protocol            = "HTTP"
    timeout             = 3
    unhealthy_threshold = 2
  }
}
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
resource "aws_lb_target_group_attachment" "attach-app1" {
  count            = length(aws_instance.api)
  target_group_arn = aws_lb_target_group.front.arn
  target_id        = element(aws_instance.api.*.id, count.index)
  port             = 8000
}
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.front.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front.arn
  }
}
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
resource "aws_lb" "front" {
  name               = "api"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = [aws_subnet.data_public_subnet.id, aws_subnet.data_public_subnet_2.id]

  enable_deletion_protection = false

  tags = {
    project = "adult api"
  }
}