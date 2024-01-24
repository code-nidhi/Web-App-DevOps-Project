variable "aks_cluster_name" {
  description = "The name of the AKS cluster to be created."
  type        = string
}

variable "cluster_location" {
  description = "The Azure region where the AKS cluster will be deployed to."
  type        = string
}

variable "dns_prefix" {
  description = "The DNS prefix of cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "The Kubernetes version the cluster will use."
  type        = string
}

variable "service_principal_client_id" {
  description = "Provides the Client ID for the service principal associated with the cluster."
  type        = string
}

variable "service_principal_client_secret" {
  description = "Provides the Client Secret for the service principal."
  type        = string
}

# Input variables from the networking module
variable "resource_group_name" {
  description = "The name of the Azure Resource Group where the networking resources will be deployed in."
  type        = string
}

variable "vnet_id" {
  description = "Used within the cluster module to connect the cluster to the defined VNet."
  type        = string
}

variable "control-plane-subnet" {
  description = "Used to specify the subnet where the control plane components of the AKS cluster will be deployed to."
  type        = string
}

variable "worker_node_subnet_id" {
  description = "Used to specify the subnet where the worker nodes of the AKS cluster will be deployed to."
  type        = string
}

# aks nsg id