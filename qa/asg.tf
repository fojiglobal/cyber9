resource "aws_launch_template" "qa_lt" {
  name = "${var.env}-lt"

  image_id = "ami-085f9c64a9b75eed5"

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t2.micro"

  key_name = "cs2-use2-main"

  vpc_security_group_ids = [aws_security_group.private_sg.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.env}-web"
    }
  }

  user_data = filebase64("web.sh")
}

################# ASG ############################

resource "aws_autoscaling_group" "qa_asg" {
  name                = "${var.env}-asg"
  vpc_zone_identifier = [aws_subnet.qa_pri_1.id, aws_subnet.qa_pri_2.id]
  desired_capacity    = 2
  max_size            = 2
  min_size            = 1
  target_group_arns   = [aws_lb_target_group.qa_tg.arn]
  launch_template {
    id      = aws_launch_template.qa_lt.id
    version = "$Latest"
  }
  tag {
    key                 = "name"
    value               = "${var.env}-web"
    propagate_at_launch = true
  }
}