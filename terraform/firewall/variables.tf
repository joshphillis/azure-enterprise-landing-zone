variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "firewall_name" {
  type = string
}

variable "firewall_pip_name" {
  type = string
}

variable "hub_vnet_name" {
  type = string
}

variable "firewall_subnet_cidr" {
  type = string
}

variable "tags" {
  type = map(string)
}