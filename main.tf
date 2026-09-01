provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "my_server" {
    ami = "ami-0b6d9d3d33ba97d99"
    instance_type = "t2.micro"
    tags = {
        Name = "simple-server-new"
    }
    vpc_security_group_ids = [ aws_security_group.instance.id ]
    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World" > index.html
                nohup busybox httpd -f -p ${var.webserver_port_number} &
                EOF
    user_data_replace_on_change = true
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
}

output "public_ip" {
    value = aws_instance.my_server.public_ip
    description = "This is public ip address of web server"
  
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

# $env:AWS_ACCESS_KEY_ID="<ACCESS_KEY>"  
# $env:AWS_SECRET_ACCESS_KEY="<SECRET_KEY>"