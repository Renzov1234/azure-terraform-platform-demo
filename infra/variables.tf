variable "location" {
  description = "Azure region for resources."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "tags" {
  description = "Common tags to apply to resources."
  type        = map(string)
  default     = {}
}
