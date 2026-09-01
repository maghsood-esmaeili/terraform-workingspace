provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "my_server" {
    ami = "ami-0b6d9d3d33ba97d99"
    instance_type = "t2.micro"
    tags = {
        Name = "simple-server-new"
    }
  
}

# $env:AWS_ACCESS_KEY_ID="<ACCESS_KEY>"  
# $env:AWS_SECRET_ACCESS_KEY="<SECRET_KEY>"