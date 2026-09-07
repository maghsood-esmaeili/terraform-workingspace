module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"
  cluster_name = "webserver-stage"
  db_remote_state_bucket = "terraform-up-and-running-maghsood"
  db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"
  instance_type = "t2.micro"
  min_size = 1
  max_size = 2
  
}