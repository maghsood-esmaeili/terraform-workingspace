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
  enable_autoscaling = true
}

module "lightsail_project" {
  source = "../../../../modules/services/serverless/lightsail"
  lightsail_name = "my_web_server"
  availability_zone = "us-east-1a"
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