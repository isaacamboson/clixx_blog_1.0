
#creating load balancer
resource "aws_lb" "blog_lb" {
  name                       = "${local.BlogPrefix}-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.stack-sg.id, aws_security_group.app-server-sg.id, aws_security_group.bastion-sg.id]
  subnets                    = [aws_subnet.pub_subnet_1.id, aws_subnet.pub_subnet_2.id]
  enable_deletion_protection = false
}

#creating load balancer target group
resource "aws_lb_target_group" "blog_lb_target_group" {
  name        = "${local.BlogPrefix}-lb-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc_main.id
  depends_on  = [aws_lb.blog_lb]
}

resource "aws_lb_listener" "blog-lb-listener" {
  load_balancer_arn = aws_lb.blog_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blog_lb_target_group.arn
  }
}

# resource "aws_lb_target_group_attachment" "blog-tg-attachment" {
#   # count            = length(aws_instance.aws_server_blog_az_a)
#   target_group_arn = aws_lb_target_group.blog_lb_target_group.arn
#   # target_id        = aws_instance.aws_server_blog_az_a[count.index].id
#   target_id = aws_lb.blog_lb.arn
#   port             = 80
# }

# resource "aws_lb_target_group_attachment" "blog-tg-attachment_az_b" {
#   count            = length(aws_instance.aws_server_blog_az_b)
#   target_group_arn = aws_lb_target_group.blog_lb_target_group.arn
#   target_id        = aws_instance.aws_server_blog_az_b[count.index].id
#   port             = 80
# }

#creating Launch Template
resource "aws_launch_template" "blog-app-launch-temp" {
  name          = "${local.BlogPrefix}-launch-temp"
  image_id      = data.aws_ami.stack_ami.image_id
  instance_type = var.EC2_Components["instance_type"]
  key_name      = aws_key_pair.stack_key_pair.key_name
  user_data     = filebase64("${path.module}/scripts/bootstrap_blog.sh")

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.stack-sg.id, aws_security_group.app-server-sg.id, aws_security_group.bastion-sg.id]
  }

  block_device_mappings {
    device_name = "/dev/sdb"
    ebs {
      volume_size = 10
      volume_type = "gp2"
      encrypted   = true
    }
  }

  block_device_mappings {
    device_name = "/dev/sdc"
    ebs {
      volume_size = 10
      volume_type = "gp2"
      encrypted   = true
    }
  }

  block_device_mappings {
    device_name = "/dev/sdd"
    ebs {
      volume_size = 10
      volume_type = "gp2"
      encrypted   = true
    }
  }

  block_device_mappings {
    device_name = "/dev/sde"
    ebs {
      volume_size = 10
      volume_type = "gp2"
      encrypted   = true
    }
  }

  block_device_mappings {
    device_name = "/dev/sdf"
    ebs {
      volume_size = 10
      volume_type = "gp2"
      encrypted   = true
    }
  }

  tags = {
    Name = "Blog_Instance"
  }

}

#creating Auto Scaling Group
resource "aws_autoscaling_group" "blog_app_asg" {
  name                      = "${local.BlogPrefix}-asg"
  desired_capacity          = 1
  max_size                  = 4
  min_size                  = 1
  health_check_grace_period = 30
  health_check_type         = 1800
  vpc_zone_identifier       = [aws_subnet.pub_subnet_1.id, aws_subnet.pub_subnet_2.id]
  target_group_arns         = [aws_lb_target_group.clixx_lb_target_group.arn]
  default_cooldown          = 300

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  launch_template {
    id      = aws_launch_template.blog-app-launch-temp.id
    version = aws_launch_template.blog-app-launch-temp.latest_version
  }

  depends_on = [aws_lb.blog_lb]
}

#scaling up policy
resource "aws_autoscaling_policy" "scaling_up_blog" {
  name                   = "${local.BlogPrefix}-asg-scaling-up"
  autoscaling_group_name = aws_autoscaling_group.blog_app_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "60"
  policy_type            = "SimpleScaling"
}

# scale up alarm
# alarm will trigger the ASG policy (scale/down) based on the metric (CPUUtilization), comparison_operator, threshold
resource "aws_cloudwatch_metric_alarm" "scale_up_alarm_blog" {
  alarm_name          = "${local.BlogPrefix}-asg-scale-up-alarm"
  alarm_description   = "asg-scale-up-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.blog_app_asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scaling_up_blog.arn]
}

# #scaling down policy
# resource "aws_autoscaling_policy" "scaling_down_blog" {
#   name                   = "${local.BlogPrefix}-asg-scaling-down"
#   autoscaling_group_name = aws_autoscaling_group.blog_app_asg.name
#   adjustment_type        = "ChangeInCapacity"
#   scaling_adjustment     = "-1"
#   cooldown               = "30"
#   policy_type            = "SimpleScaling"
# }

# # scale down alarm
# resource "aws_cloudwatch_metric_alarm" "scale_down_alarm_blog" {
#   alarm_name          = "${local.BlogPrefix}-asg-scale-down-alarm"
#   alarm_description   = "asg-scale-down-cpu-alarm"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = "120"
#   statistic           = "Average"
#   threshold           = "10" # Instance will scale down when CPU utilization is lower than 5 %
#   dimensions = {
#     "AutoScalingGroupName" = aws_autoscaling_group.blog_app_asg.name
#   }
#   actions_enabled = true
#   alarm_actions   = [aws_autoscaling_policy.scaling_down_blog.arn]
# }

