variable "lightsail_name" {
    type = string
    default = "example_1"
}

variable "availability_zone" {
      type = string
      default = "us-east-1b"
}

variable "blueprint_id" {
      type = string
      default = "amazon_linux_2"
}
variable "bundle_id" {
      type = string
      default = "nano_3_0"
}