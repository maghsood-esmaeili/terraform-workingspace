provider "aws" {
  
}

resource "aws_instance" "example" {
    ami = "ami-0fb653ca2d3203ac1"
    instance_type = "t2.micro"
}

data "aws_iam_policy_document" "assume_role" {
    statement {
      effect = "Allow"
      actions = [ "sts:AssumeRole" ]
      principals {
        type = "Service"
        identifiers = [ "ec2.amazonaws.com" ]
      }
    }
}

resource "aws_iam_role" "instance" {
    name = "iam_role_instance"
    assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "ec2_admin_permissions" {
    statement {
      effect = "Allow"
      actions = [ "ec2:*" ]
      resources = [ "*" ]
    }
}
resource "aws_iam_role_policy" "example" {
    role = aws_iam_role.instance.id
    policy = data.aws_iam_policy_document.ec2_admin_permissions.json
  
}