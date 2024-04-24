
#-------------------------------------------------------------------------
#creating load balancer
#-------------------------------------------------------------------------

resource "aws_lb" "blog_lb" {
  name                       = "${local.BlogPrefix}-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.stack-sg.id, aws_security_group.bastion-sg.id]
  subnets                    = [aws_subnet.pub_subnet_1.id, aws_subnet.pub_subnet_2.id]
  enable_deletion_protection = false
}

#-------------------------------------------------------------------------
#creating target group
#-------------------------------------------------------------------------

resource "aws_lb_target_group" "blog_lb_target_group" {
  name     = "${local.BlogPrefix}-lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

#-------------------------------------------------------------------------
#creating LB listener
#-------------------------------------------------------------------------

resource "aws_lb_listener" "blog-lb-listener" {
  load_balancer_arn = aws_lb.blog_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blog_lb_target_group.arn
  }
}

#-------------------------------------------------------------------------
# creating launch configuration
#-------------------------------------------------------------------------

resource "aws_launch_configuration" "blog-launch-config" {
  name_prefix                 = "${local.BlogPrefix}-app-launch-config"
  image_id                    = data.aws_ami.stack_ami.image_id
  instance_type               = var.EC2_Components["instance_type"]
  security_groups             = [aws_security_group.app-server-sg.id, aws_security_group.bastion-sg.id]
  user_data                   = data.template_file.bootstrap_blog.rendered
  associate_public_ip_address = true
  key_name                    = "private-key-kp"

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type           = var.EC2_Components["volume_type"]
    volume_size           = var.EC2_Components["volume_size"]
    delete_on_termination = var.EC2_Components["delete_on_termination"]
    encrypted             = var.EC2_Components["encrypted"]
  }

  dynamic "ebs_block_service" {
    for_each = var.device_names
    content {
      device_name = ebs_block_device.value
      volume_size = 10
      volume_type = "gp2"
      encrypted = true
    }    
  }

  # ebs_block_device {
  #   device_name = "/dev/sdb"
  #   volume_size = 10
  #   volume_type = "gp2"
  #   encrypted   = true
  # }

  # ebs_block_device {
  #   device_name = "/dev/sdc"
  #   volume_size = 10
  #   volume_type = "gp2"
  #   encrypted   = true
  # }

  # ebs_block_device {
  #   device_name = "/dev/sdd"
  #   volume_size = 10
  #   volume_type = "gp2"
  #   encrypted   = true
  # }

  # ebs_block_device {
  #   device_name = "/dev/sde"
  #   volume_size = 10
  #   volume_type = "gp2"
  #   encrypted   = true
  # }

  # ebs_block_device {
  #   device_name = "/dev/sdf"
  #   volume_size = 10
  #   volume_type = "gp2"
  #   encrypted   = true
  # }
}

#-------------------------------------------------------------------------
#creating Auto Scaling Group
#-------------------------------------------------------------------------

resource "aws_autoscaling_group" "blog_app_asg" {
  name                      = "${local.BlogPrefix}-asg"
  launch_configuration      = aws_launch_configuration.blog-launch-config.name
  desired_capacity          = 4
  max_size                  = 6
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  vpc_zone_identifier       = [aws_subnet.prv_subnet_1.id, aws_subnet.prv_subnet_6.id]
  target_group_arns         = [aws_lb_target_group.blog_lb_target_group.arn]
  default_cooldown          = 300

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  tag {
    key                 = "Name"
    value               = "Blog"
    propagate_at_launch = true
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

#scaling down policy
resource "aws_autoscaling_policy" "scaling_down_blog" {
  name                   = "${local.BlogPrefix}-asg-scaling-down"
  autoscaling_group_name = aws_autoscaling_group.blog_app_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "30"
  policy_type            = "SimpleScaling"
}

# scale down alarm
resource "aws_cloudwatch_metric_alarm" "scale_down_alarm_blog" {
  alarm_name          = "${local.BlogPrefix}-asg-scale-down-alarm"
  alarm_description   = "asg-scale-down-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "20" # Instance will scale down when CPU utilization is lower than 5 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.blog_app_asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scaling_down_blog.arn]
}

