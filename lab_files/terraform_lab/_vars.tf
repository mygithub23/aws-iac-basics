variable "admin_group" {
  description = "Define the administrative group responsible for the server.  Will be set to the global admins by default.  Should be updated for specific instances."
  type        = string
  default     = "fin_global_admins@ourcompany.com"
}

variable "target_region" {
  description = "Define the target region for the deployment."
  type        = string
  default     = "us-east-1"
}


variable "cost_center" {
  description = "Define the target region for the deployment."
  type        = string
  default     = "Finance"
}