module "webserver_cluster" {
  source = "github.com/maghsood-esmaeili/terraform-asg-module/tree/v0.0.1/services/webserver-cluster"
  cluster_name = "webserver-prod"
  db_remote_state_bucket = "terraform-up-and-running-maghsood-new"
  db_remote_state_key = "prod/data-stores/mysql/terraform.tfstate"
  instance_type = "t2.micro"
  min_size = 2
  max_size = 4
  enable_autoscaling = true
  
}
