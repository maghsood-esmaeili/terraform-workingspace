variable "users" {
  type        = list(string)
  default     = ["maghsood", "ghazal", "neo"]
  description = "here is the list of users"
}

variable "users_ability" {
  type = map(string)
  default = {
    "maghsood" = "earth-bander"
    "ghazal"   = "fire-bander"
    "neo"      = "air-bander"
  }
}

variable "give_neo_cloudwatch_full_access" {
  description = "Give full access to neo user on cloudwatch"
  type        = bool
  default     = false
}