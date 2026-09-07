provider "aws" {
    region = "us-east-1"
  
}
resource "aws_db_instance" "example" {
    identifier_prefix = "terraform-up-and-running"
    engine = "mysql"
    allocated_storage = 10
    instance_class = "db.t3.micro"
    skip_final_snapshot = true
    db_name = "example_database"

    username = var.db_username
    password = var.db_password
}

terraform {
  backend "s3" {
    bucket = "terraform-up-and-running-maghsood"
    key = "stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform_up_and_running_lock_table"
    use_lockfile = true
    encrypt = true
    
  }
}

# run terraform init and apply ...