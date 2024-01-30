variable "client_id" {
  description = "Access key for the provider"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Secret key for the provider"
  type        = string
  sensitive   = true
}

variable "subscription_id" {
  description = "Subscription id value"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Tenant id value"
  type        = string
  sensitive   = true
}




