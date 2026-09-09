locals {
  http_port = 80
  any_port = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips = ["0.0.0.0/0"]
}

resource "aws_launch_configuration" "ASG_config" {
    image_id = "ami-0b6d9d3d33ba97d99"
    instance_type = var.instance_type
    
    security_groups = [ aws_security_group.instance.id ]
    user_data = templatefile("${path.module}/user-data.sh", {
        server_port = var.webserver_port_number
        db_address = data.terraform_remote_state.db.outputs.address
        db_port = data.terraform_remote_state.db.outputs.port
    })

}
resource "aws_autoscaling_group" "ASG_example" {
  launch_configuration = aws_launch_configuration.ASG_config.name
  vpc_zone_identifier =  data.aws_subnets.default.ids

  target_group_arns = [ aws_lb_target_group.asg.arn ]
  health_check_type = "ELB"

  min_size = var.min_size
  max_size = var.max_size
  tag {
    key = "Name"
    value = "${var.cluster_name}-asg"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "asg" {
    listener_arn = aws_lb_listener.http.arn
    priority = 100
    condition {
      path_pattern {
        values = ["*"]
      }
    }
    action {
      type = "forward"
      target_group_arn = aws_lb_target_group.asg.arn
    }
  
}
resource "aws_lb" "alb_sample" {
    name = "${var.cluster_name}-asg"
    load_balancer_type = "application"
    subnets = data.aws_subnets.default.ids
    security_groups = [ aws_security_group.alb.id ]
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.alb_sample.arn
    port = local.http_port
    protocol = "HTTP"

    default_action {
      type = "fixed-response"
      fixed_response {
        content_type = "text/plain"
        message_body =  "404: page not found"
        status_code = 404
    }
    }
  
}

resource "aws_lb_target_group" "asg" {
    name = "terraform-asg-example"
    port = var.webserver_port_number
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id
    health_check {
      path = "/"
      protocol = "HTTP"
      matcher = 200
      interval = 15
      timeout = 10
      healthy_threshold = 2
      unhealthy_threshold = 2
    }
  
}
resource "aws_security_group_rule" "alb_inbound" {
    security_group_id = aws_security_group.alb.id
    type = "ingress"
    from_port = local.http_port
    to_port = local.http_port
    protocol = local.tcp_protocol
    cidr_blocks = local.all_ips 
}
resource "aws_security_group_rule" "alb_outbound" {
  security_group_id = aws_security_group.alb.id
  type = "egress"
  from_port = local.any_port
  to_port = local.any_port
  protocol = local.any_protocol
  cidr_blocks = local.all_ips
}
resource "aws_security_group" "alb" {
    name = "${var.cluster_name}-alb"
}


data "aws_subnets" "default" {
  filter {
    name = "vpc-id"
    values = [ data.aws_vpc.default.id ]
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "instance" {
    name = "ingress-webserver"
    ingress {
        from_port = var.webserver_port_number
        to_port = var.webserver_port_number
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
  
}

variable "webserver_port_number" {
    description = "port number for web server"
    type = number  
    default = 8080
}



variable "object_example" {
    description = "An example of a structureal type in Terraform"
    type = object({
      name = string
      age = number
      tag = list(string)
      enabled = bool
    })
    default = {
      name = "maghsood"
      age = 31
      tag = [ "software engineer", "DevOps", "Cloud Engineer" ]
      enabled = true
    }
  
}
data "terraform_remote_state" "db" {
    backend = "s3"
    config =  {
        bucket = "${var.db_remote_state_bucket}"
        key = "${var.db_remote_state_key}"
        region = "us-east-1"
    }
}

output "asg_name" {
    value = aws_autoscaling_group.ASG_example.name
    description = "The name of the Auto Scaling Group"
}
output "alb_security_group_id" {
    value = aws_security_group.alb.id
    description = "The ID of the Security Group attached to the load balancer"
  
}