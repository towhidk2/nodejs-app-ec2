
locals {
    private-subnet-1            = aws_subnet.private[element(keys(aws_subnet.private),0)].id
    private-subnet-2            = aws_subnet.private[element(keys(aws_subnet.private),1)].id
    private-subnet-3            = aws_subnet.private[element(keys(aws_subnet.private),2)].id
}


# autoscaling group allows you to dynamically control your server pool size – increase it, when servers are processing more traffic or tasks than usual, or decrease it, when it become quieter.
resource "aws_autoscaling_group" "asg" {
    name                        = "asg"
    # vpc_zone_identifier         = [local.public-subnet-1, local.public-subnet-2, local.public-subnet-3]
    vpc_zone_identifier         = [local.private-subnet-1, local.private-subnet-2, local.private-subnet-3]
    desired_capacity            = 2
    max_size                    = 5
    min_size                    = 2

    # health_check_type    = "ELB"
    # load_balancers              = [aws_lb.myapp_alb.arn]
    target_group_arns           = [aws_lb_target_group.myapp_tg.arn]

    launch_template {
        id                      = aws_launch_template.ec2.id
        version                 = "$Latest"
    }
    
    # required to redeploy without an outage
    lifecycle {
        create_before_destroy   = true
    }

    tag {
        key                     = "Name"
        value                   = "asg"
        propagate_at_launch     = true
    }

    depends_on = [aws_lb.myapp_alb, aws_lb_target_group.myapp_tg]
}


# aws_autoscaling_policy declares how aws should change autoscaling group instances count in case of aws_cloudwatch_metric_alarm
# scale up(scale out) auto scaling policy
resource "aws_autoscaling_policy" "cpu-scale-out" {
    name                            = "cpu-scale-out"
    autoscaling_group_name          = aws_autoscaling_group.asg.id
    adjustment_type                 = "ChangeInCapacity"
    # cooldown                        = "300"
    policy_type                     = "StepScaling"

    # bounds are relative to the alarm threshold 
    step_adjustment {
        scaling_adjustment          = 0
        metric_interval_lower_bound = 0
        metric_interval_upper_bound = 10
    }

    step_adjustment {
        scaling_adjustment          = 1
        metric_interval_lower_bound = 10
        metric_interval_upper_bound = 20
    }

    step_adjustment {
        scaling_adjustment          = 2
        metric_interval_lower_bound = 20
        # metric_interval_upper_bound = ""
    }
}


# aws_cloudwatch_metric_alarm will be fired, if total cpu utilization of all instances in our autoscaling group will be greater or equal threshold (50% cpu utilization) during 120 seconds.
resource "aws_cloudwatch_metric_alarm" "cpu-more-than-40" {
    alarm_name                      = "cpu-more-than-40"
    alarm_description               = "cpu-more-than-40"
    comparison_operator             = "GreaterThanOrEqualToThreshold"
    evaluation_periods              = "2"
    metric_name                     = "CPUUtilization"
    namespace                       = "AWS/EC2"
    period                          = "60"
    statistic                       = "Average"
    threshold                       = "40"

    dimensions = {
        AutoScalingGroupName        = aws_autoscaling_group.asg.id
  }

    actions_enabled                 = true
    alarm_actions                   = [aws_autoscaling_policy.cpu-scale-out.arn]
}


# scale down(scale in) auto scaling policy
resource "aws_autoscaling_policy" "cpu-scale-in" {
    name                            = "cpu-scale-in"
    autoscaling_group_name          = aws_autoscaling_group.asg.id
    adjustment_type                 = "ChangeInCapacity"
    policy_type                     = "StepScaling"

    # bounds are relative to the alarm threshold
    step_adjustment {
        scaling_adjustment          = 0
        metric_interval_lower_bound = -10
        metric_interval_upper_bound = 0
    }

    step_adjustment {
        scaling_adjustment          = -1
        metric_interval_lower_bound = -20
        metric_interval_upper_bound = -10
    }

    step_adjustment {
        scaling_adjustment          = -2
        # metric_interval_lower_bound = null
        metric_interval_upper_bound = -20
    }
}


# aws_cloudwatch_metric_alarm will be fired, if total cpu utilization of all instances in our autoscaling group will be less or equal threshold (30% cpu utilization) during 120 seconds.
resource "aws_cloudwatch_metric_alarm" "cpu-less-than-30" {
    alarm_name                      = "cpu-less-than-30"
    alarm_description               = "cpu-less-than-30"
    comparison_operator             = "LessThanOrEqualToThreshold"
    evaluation_periods              = "2"
    metric_name                     = "CPUUtilization"
    namespace                       = "AWS/EC2"
    period                          = "60"
    statistic                       = "Average"
    threshold                       = "30"

    dimensions = {
        AutoScalingGroupName        = aws_autoscaling_group.asg.id
    }

    actions_enabled                 = true
    alarm_actions                   = [aws_autoscaling_policy.cpu-scale-in.arn]
}