module "data_store" {
  source = "../../../modules/data-stores/mysql"
  db_username = var.db_username
  db_password = var.db_password
}
terraform {
  backend "s3" {
    bucket = "terraform-up-and-running-maghsood-new"
    key = "prod/data-stores/mysql/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform_up_and_running_lock_table"
    use_lockfile = true
    encrypt = true
    
  }
}

# run terraform init and apply ...