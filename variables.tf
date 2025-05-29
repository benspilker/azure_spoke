variable "resource_group_name" {
  type    = string
  default = null
}

variable "create_resource_group" {
  type    = bool
  default = true
}

variable "location" {
  type    = string
  default = null
}

variable "spoke_vnet_details" {
  type = object({
    name          = string
    address_space = list(string)
    subnets = map(object({
      name             = string
      address_prefixes = list(string)
      nsg_name         = string
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
    associated_route_table_name = string
  })
  description = "Source VNet object with optional list of subnets"
}

variable "hub_vnet_details" {
  type = object({
    hub_subscription_id     = string
    spoke_subscription_id     = string
    resource_group_name = string
    name                = string
    firewall_ip         = optional(string, null)
    firewall_route_name = optional(string, "fw-rt")
  })
  description = "Lookup information for the Hub VNet to establish connection"
}

variable "peering_details" {
  type = object({
    hub_to_spoke_peer_name              = string
    spoke_to_hub_peer_name              = string
    allow_remote_gateways_from_hub_peer = optional(bool, false)
  })
  description = "Lookup information for the Hub VNet to establish connection"
}

variable "tags" {
  type    = map(string)
  default = {}
}