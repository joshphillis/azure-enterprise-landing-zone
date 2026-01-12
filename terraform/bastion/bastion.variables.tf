variable "resource_group_name"   { type = string }
variable "location"              { type = string }
variable "virtual_network_name"  { type = string }
variable "bastion_name"          { type = string }
variable "bastion_subnet_name"   { type = string }
variable "bastion_subnet_prefix" { type = string }
variable "tags"                  { type = map(string) }
