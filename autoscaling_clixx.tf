
#-------------------------------------------------------------------------
#creating load balancer
#-------------------------------------------------------------------------

resource "aws_lb" "clixx_lb" {
  name               = "${local.ApplicationPrefix}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.stack-sg.id, aws_security_group.bastion-sg.id]
  subnets            = tolist(aws_subnet.pub_subnets.*.id)
  enable_deletion_protection = false
}

#-------------------------------------------------------------------------
#creating target group
#-------------------------------------------------------------------------

resource "aws_lb_target_group" "clixx_lb_target_group" {
  name     = "${local.ApplicationPrefix}-lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id     = aws_vpc.vpc_main.id
  depends_on = [aws_lb.clixx_lb]

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

resource "aws_lb_listener" "clixx-lb-listener" {
  load_balancer_arn = aws_lb.clixx_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.clixx_lb_target_group.arn
  }
}

#-----------------------------------------------------------------------------
#creating Launch Template for the autoscaling group instances
#-----------------------------------------------------------------------------

resource "aws_launch_template" "clixx-app-launch-temp" {
  name                   = "${local.ApplicationPrefix}-launch-temp"
  image_id               = data.aws_ami.stack_ami.image_id
  instance_type          = var.EC2_Components["instance_type"]
  key_name               = "private-key-kp"
  user_data              = base64encode(data.template_file.bootstrap.rendered)
  vpc_security_group_ids = [aws_security_group.app-server-sg.id, aws_security_group.bastion-sg.id]

  monitoring {
    enabled = true
  }

  dynamic "block_device_mappings" {
    for_each = var.device_names
    content {
      device_name = block_device_mappings.value

      ebs {
        volume_size = 10
        volume_type = "gp2"
        encrypted   = true
      }
    }
  }

  tags = {
    Name = "${local.ApplicationPrefix}_Instance"
  }
}

#-----------------------------------------------------------------------------
## Creates an ASG linked with our main VPC
#-----------------------------------------------------------------------------

resource "aws_autoscaling_group" "clixx_app_asg" {
  name                      = "${local.ApplicationPrefix}_ASG_${var.environment}"
  desired_capacity          = 4
  max_size                  = 6
  min_size                  = 2
  health_check_grace_period = 300
  vpc_zone_identifier       = [aws_subnet.private_subnets[0].id, aws_subnet.private_subnets[1].id]
  health_check_type         = "EC2"
  target_group_arns         = [aws_lb_target_group.clixx_lb_target_group.arn]
  default_cooldown          = 300
  protect_from_scale_in     = true

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  launch_template {
    id      = aws_launch_template.clixx-app-launch-temp.id
    version = "$Latest"
  }

  # lifecycle {
  #   create_before_destroy = true
  # }

  tag {
    key                 = "Name"
    value               = "${local.ApplicationPrefix}_ASG_${var.environment}"
    propagate_at_launch = true
  }

  depends_on = [aws_lb.clixx_lb]
}


#scaling up policy
resource "aws_autoscaling_policy" "scaling_up" {
  name                   = "${local.ApplicationPrefix}-asg-scaling-up"
  autoscaling_group_name = aws_autoscaling_group.clixx_app_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "60" #Amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start.
  policy_type            = "SimpleScaling"
}

# scale up alarm
# alarm will trigger the ASG policy (scale/down) based on the metric (CPUUtilization), comparison_operator, threshold
resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "${local.ApplicationPrefix}-asg-scale-up-alarm"
  alarm_description   = "asg-scale-up-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.clixx_app_asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scaling_up.arn]
}

#scaling down policy
resource "aws_autoscaling_policy" "scaling_down" {
  name                   = "${local.ApplicationPrefix}-asg-scaling-down"
  autoscaling_group_name = aws_autoscaling_group.clixx_app_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "30"
  policy_type            = "SimpleScaling"
}

# scale down alarm
resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "${local.ApplicationPrefix}-asg-scale-down-alarm"
  alarm_description   = "asg-scale-down-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "20" # Instance will scale down when CPU utilization is lower than 5 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.clixx_app_asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scaling_down.arn]
}

