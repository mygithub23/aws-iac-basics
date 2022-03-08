variable "admin_group" {
  description = "Define the administrative group responsible for the server.  Will be set to the global admins by default.  Should be updated for specific instances."
  type        = string
  default     = "global_admins_group"
}

