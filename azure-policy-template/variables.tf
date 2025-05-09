variable "tenant_id" {
  description = "Azure Active Directory tenant ID"
  type        = string
}

variable "location" {
  description = "Azure region for resource group"
  type        = string
  default     = "East US"
}

variable "target_scope" {
  description = "Scope for policy assignment (subscription or management group ID)"
  type        = string
}
