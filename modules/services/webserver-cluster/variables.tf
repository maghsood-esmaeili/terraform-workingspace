variable "cluster_name" {
    description = "The name to use for all the cluster resources"
    type = string
}

variable "db_remote_state_bucket" {
    description = "The name of the s3 bucket for the database"
    type = string
}
variable "db_remote_state_key" {
    description = "The path for the database remote state in s3"
    type = string 
}
variable "instance_type" {
    description = "The type of EC2 Instances to run"
    type = string
}
variable "min_size" {
    description = "The minimum number of EC2 Instances in the ASG"
    type = number
}

variable "max_size" {
    description = "The maximum number of EC2 Instances in the ASG"
    type = number
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

variable "enable_autoscaling" {
    description = "If set to true, enable auto scaling"
    type = bool
}

variable "expose_x_port" {
    description = "Enable some random port like 12345 for stage env"
    type = bool
}
variable "custome_tags" {
    description = "Custome Tag that we want to pass from resource"
    type = map(string)
}