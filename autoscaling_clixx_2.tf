
#-------------------------------------------------------------------------
#creating load balancer
#-------------------------------------------------------------------------

resource "aws_lb" "clixx_lb" {
  name                       = "${local.ApplicationPrefix}-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.stack-sg.id, aws_security_group.app-server-sg.id, aws_security_group.bastion-sg.id]
  subnets                    = [aws_subnet.pub_subnet_1.id, aws_subnet.pub_subnet_2.id]
  enable_deletion_protection = false
}

#-------------------------------------------------------------------------
#creating target group
#-------------------------------------------------------------------------

resource "aws_lb_target_group" "clixx_lb_target_group" {
  name     = "${local.ApplicationPrefix}-lb-target-group"
  port     = 80
  protocol = "HTTP"
  #   target_type = "instance"
  vpc_id     = aws_vpc.vpc_main.id
  depends_on = [aws_lb.clixx_lb]

  health_check {
    # path                = "/index.html"
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

#-------------------------------------------------------------------------
# creating launch configuration
#-------------------------------------------------------------------------

resource "aws_launch_configuration" "clixx-launch-config" {
  name_prefix     = "${local.ApplicationPrefix}-app-launch-config"
  image_id        = data.aws_ami.stack_ami.image_id
  instance_type   = var.EC2_Components["instance_type"]
  security_groups = [aws_security_group.app-server-sg.id, aws_security_group.bastion-sg.id]
  #   user_data                   = filebase64("${path.module}/scripts/bootstrap.sh")
  user_data                   = data.template_file.bootstrap.rendered
  associate_public_ip_address = true
  key_name                    = aws_key_pair.stack_key_pair.key_name

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type           = var.EC2_Components["volume_type"]
    volume_size           = var.EC2_Components["volume_size"]
    delete_on_termination = var.EC2_Components["delete_on_termination"]
    encrypted             = var.EC2_Components["encrypted"]
  }

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = 10
    volume_type = "gp2"
    encrypted   = true
  }

  ebs_block_device {
    device_name = "/dev/sdc"
    volume_size = 10
    volume_type = "gp2"
    encrypted   = true
  }

  ebs_block_device {
    device_name = "/dev/sdd"
    volume_size = 10
    volume_type = "gp2"
    encrypted   = true
  }

  ebs_block_device {
    device_name = "/dev/sde"
    volume_size = 10
    volume_type = "gp2"
    encrypted   = true
  }

  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 10
    volume_type = "gp2"
    encrypted   = true
  }

}

#-------------------------------------------------------------------------
#creating Auto Scaling Group
#-------------------------------------------------------------------------

resource "aws_autoscaling_group" "clixx_app_asg" {
  name                      = "${local.ApplicationPrefix}-asg"
  launch_configuration      = aws_launch_configuration.clixx-launch-config.name
  desired_capacity          = 4
  max_size                  = 6
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  vpc_zone_identifier       = [aws_subnet.prv_subnet_1.id, aws_subnet.prv_subnet_6.id]
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

  tag {
    key = "Name"
    value = "Clixx-App"
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

# #scaling down policy
# resource "aws_autoscaling_policy" "scaling_down" {
#   name                   = "${local.ApplicationPrefix}-asg-scaling-down"
#   autoscaling_group_name = aws_autoscaling_group.clixx_app_asg.name
#   adjustment_type        = "ChangeInCapacity"
#   scaling_adjustment     = "-1"
#   cooldown               = "30"
#   policy_type            = "SimpleScaling"
# }

# scale down alarm
# resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
#   alarm_name          = "${local.ApplicationPrefix}-asg-scale-down-alarm"
#   alarm_description   = "asg-scale-down-cpu-alarm"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = "120"
#   statistic           = "Average"
#   threshold           = "10" # Instance will scale down when CPU utilization is lower than 5 %
#   dimensions = {
#     "AutoScalingGroupName" = aws_autoscaling_group.clixx_app_asg.name
#   }
#   actions_enabled = true
#   alarm_actions   = [aws_autoscaling_policy.scaling_down.arn]
# }

