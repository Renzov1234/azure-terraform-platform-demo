variable "project_name" {
  type        = string
  description = "Short project name used for resource naming."
}

variable "environment" {
  type        = string
  description = "Environment name (dev)."
  validation {
    condition     = contains(["dev"], var.environment)
    error_message = "Only 'dev' is supported in this repo."
  }
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Existing RG where resources will be deployed."
}

variable "app_insights_daily_cap_gb" {
  type        = number
  description = "Daily data cap (GB) to control App Insights cost."
  default     = 0.05
}
