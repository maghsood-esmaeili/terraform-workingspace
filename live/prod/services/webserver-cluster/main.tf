module "webserver_cluster" {
  source = "github.com/maghsood-esmaeili/terraform-asg-module/tree/v0.0.1/services/webserver-cluster"
  cluster_name = "webserver-prod"
  db_remote_state_bucket = "terraform-up-and-running-maghsood-new"
  db_remote_state_key = "prod/data-stores/mysql/terraform.tfstate"
  instance_type = "t2.micro"
  min_size = 2
  max_size = 4
}
resource "aws_autoscaling_schedule" "scaling_out_during_buisness_hours" {
  scheduled_action_name = "scale-out-during-business-hours"
  min_size = 1
  max_size = 2
  desired_capacity = 2
  recurrence = "0 9 * * *"
  autoscaling_group_name = module.webserver_cluster.asg_name
}

resource "aws_autoscaling_schedule" "scaling_in_at_night" {
  scheduled_action_name = "scale-in-at-night"
  min_size = 2
  max_size = 1
  desired_capacity = 1
  recurrence = "0 17 * * *"
  autoscaling_group_name = module.webserver_cluster.asg_name
}