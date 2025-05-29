# Azure Location
variable "location" {
  type = string
}

# RJF Naming Metadata
variable "biz_shortname" {
  type = string
}

variable "environment" {
  type = string
}

# Spoke VNet Details
variable "spoke_address_space" {
  type = list(string)
}

variable "spoke_subnets" {
  type = map(object({
    name             = string
    address_prefixes = list(string)
    security_rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
}

variable "hub_vnet_details" {
  type = object({
    hub_subscription_id     = string
    spoke_subscription_id     = string
    resource_group_name = string
    name                = string
    firewall_ip         = optional(string, null)
  })
  description = "Lookup information for the Hub VNet to establish connection"
}

variable "tags" {
  type = map(string)
}