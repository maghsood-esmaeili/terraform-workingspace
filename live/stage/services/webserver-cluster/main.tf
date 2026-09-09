provider "aws" {
  region = "us-east-1" 
}
module "webserver_cluster" {
  source = "github.com/maghsood-esmaeili/terraform-asg-module/tree/v0.0.1/services/webserver-cluster"
  cluster_name = "webserver-stage"
  db_remote_state_bucket = "terraform-up-and-running-maghsood-new"
  db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"
  instance_type = "t2.micro"
  min_size = 1
  max_size = 2
}

resource "aws_security_group_rule" "inbound_port" {
  security_group_id = module.webserver_cluster.alb_security_group_id
  type = "ingress"
  from_port = 12345
  to_port = 12345
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"] 
  
}

terraform {
  backend "s3" {
    bucket = "terraform-up-and-running-maghsood-new"
    key = "stage/service/webserver_cluster/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform_up_and_running_lock_table"
    use_lockfile = true
    encrypt = true
    
  }
}